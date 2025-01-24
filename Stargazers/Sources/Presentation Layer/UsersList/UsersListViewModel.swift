//
//  UsersListViewModel.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 21/01/25.
//

import Foundation
import UIKit
import Combine

typealias User = StargazersAPI.User

enum Status: Equatable {
    case loading
    case finished(error: FetchError?)
    
    static func == (lhs: Status, rhs: Status) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.finished(_), .finished(_)):
            return true
        default:
            return false
        }
    }
}

final class UsersListViewModel: BaseViewModel {
    var coordinator: (any Coordinator)?
    
    @Published var dataSource: [UserCellConfiguration] = []
    @Published var status: Status = .loading
    
    private let owner: String
    private let repo: String
    
    
    private let numberElementsPerPage = "30"
    private var currentPage: Int = 1
    private var lastPage: Int = 0
    
    
    init(coordinator: (any Coordinator)? = nil, owner: String, repo: String) {
        self.coordinator = coordinator
        self.owner = owner
        self.repo = repo
        
        Task {
            dataSource = try await search(with: owner, and: repo)
        }
    }
    
    func fetchMoreData() {
        guard currentPage < lastPage else { return }
        status = .loading
        currentPage += 1
        Task {
            let newStargazersList = try await search(with: owner, and: repo)
            dataSource.append(contentsOf: newStargazersList)
        }
    }
    
    
    //MARK: Private
    private func search(with ownerName: String, and repositoryName: String) async throws -> [UserCellConfiguration] {
        var users: [UserCellConfiguration] = []
        
        do {
            let stargazers = try await fetchStargazesApi(owner: ownerName, repo: repositoryName)
            users = await configureDataSource(from: stargazers)
            self.status = .finished(error: nil)
            return users
        }
        catch {
            self.status = .finished(error: error as? FetchError)
        }
        
        return users
    }
    
    /// Fetch API data
    private func fetchStargazesApi(owner: String, repo: String) async throws -> [StargazersAPI.User] {
        let api = StargazersAPI.path.addPathParameters(parameters: [
            StargazersAPI.PathParameters.owner.rawValue : owner,
            StargazersAPI.PathParameters.repo.rawValue : repo
        ])
        
        guard let stargazeApiUrl = URL(string: api) else {
            throw FetchError.invalidURL
        }
        
        let newStargazeApiUrl = stargazeApiUrl.appending(queryItems: [
            URLQueryItem(name: StargazersAPI.QueryParameters.per_page.rawValue, value: numberElementsPerPage),
            URLQueryItem(name: StargazersAPI.QueryParameters.page.rawValue, value: String(describing: currentPage))
        ])
        
        let (data, response) = try await URLSession.shared.data(from: newStargazeApiUrl)
            
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FetchError.invalidResponse(statusCode: -1)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw FetchError.invalidResponse(statusCode: httpResponse.statusCode)
        }

        if currentPage == 1 {
            if let link = httpResponse.allHeaderFields["Link"] as? String {
                retrieveLastPage(from: link)
            }
        }
        
        do {
            return try JSONDecoder().decode([StargazersAPI.User].self, from: data)
        } catch {
            throw FetchError.decodingError
        }
    }
    
    /// Tableview datasource configuration
    private func configureDataSource(from users: [User]) async -> [UserCellConfiguration] {
        var fetchedDataSource: [UserCellConfiguration] = []
        let placeholderImage = UIImage(systemName: "person.crop.circle") ?? UIImage()
        
        do {
            /// Users avatar download
            fetchedDataSource = try await withThrowingTaskGroup(of: UserCellConfiguration?.self) { group -> [UserCellConfiguration] in
                for user in users {
                    group.addTask {
                        do {
                            let image = try await self.fetchImage(from: user.avatarURL)
                            return UserCellConfiguration(userId: user.login, userImage: image ?? placeholderImage)
                        } catch {
                            print("Errore durante il download dell'immagine da \(user.avatarURL): \(error)")
                            /// Set placeholder image if can't find it
                            return UserCellConfiguration(userId: user.login, userImage: placeholderImage)
                        }
                    }
                }

                var results: [UserCellConfiguration] = []
                for try await userCell in group {
                    if let userCell = userCell {
                        results.append(userCell)
                    }
                }
                return results
            }
        } catch {
            print("Errore durante la gestione del task group: \(error)")
        }
        
        return fetchedDataSource
    }

    /// Download user avatar
    private func fetchImage(from urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else {
            throw FetchError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw FetchError.invalidResponse(statusCode: -1)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw FetchError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        
        return UIImage(data: data)
    }
    
    /// Retrieve last page
    private func retrieveLastPage(from linkHeader: String) {
        // Regex to find page number associated to rel="last"
        let pattern = "page=(\\d+)>; rel=\"last\""

        // Regex creation
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let range = NSRange(linkHeader.startIndex..., in: linkHeader)
            if let match = regex.firstMatch(in: linkHeader, options: [], range: range) {
                // Page value
                if let pageRange = Range(match.range(at: 1), in: linkHeader) {
                    let lastPage = linkHeader[pageRange]
                    self.lastPage = Int(lastPage) ?? 0
                    print("Ultima pagina: \(lastPage)")
                }
            }
        }
    }

}
