//
//  StargazersCoordinator.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 18/01/25.
//

import UIKit

final class StargazersCoordinator: Coordinator {
    var fatherCoordinator: Coordinator? = nil
    var childCoordinato: Coordinator? = nil
    
    /// The navigation controller for the coordinator
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        navigationController.pushViewController(createHomeViewController(), animated: false)
    }
    
    private func createHomeViewController() -> HomeView {
        let formConfiguration = HomeConfiguration.FormConfiguration(
            ownerTextfield: .owner,
            repositoryTextfield: .repository,
            buttonConfiguration: DoubleButtonConfiguration(
                topButtonTitle: .searchButton,
                bottomButtonTitle: .clearButton
            )
        )
        
        let configuration = HomeConfiguration(
            logo: UIImage(),
            backgroundImage: UIImage(),
            formConfiguration: formConfiguration)
        
        let viewModel = HomeViewModel(coordinator: self, delegate: self, configuration: configuration)
        
        let homeViewController = HomeView()
        homeViewController.configure(with: viewModel)
        return homeViewController
    }
    
    private func createUsersListViewController(with owner: String, and repo: String) -> UsersListView {
        let viewModel = UsersListViewModel(coordinator: self, owner: owner, repo: repo)
        let usersListViewController = UsersListView()
        usersListViewController.configure(with: viewModel)
        return usersListViewController
    }
    
    private func navigateToStargazersList(with owner: String, and repo: String) {
        DispatchQueue.main.async {
            let usersListViewController = self.createUsersListViewController(with: owner, and: repo)
            self.navigationController.pushViewController(usersListViewController, animated: false)
        }
    }
    
}

extension StargazersCoordinator: HomeViewModelDelegate {
    
    func homeViewModelDidAskToNavigate(_ homeViewModel: HomeViewModel, with ownerName: String, and repositoryName: String) {
        navigateToStargazersList(with: ownerName, and: repositoryName)
    }
}
