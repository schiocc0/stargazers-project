//
//  NetworkManager.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 01/02/25.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func callService<T: Codable>(endpoint: String, method: HTTPMethod, pathParameters: [String: String]? = nil, queryParameters: [String: String]? = nil) async throws -> CallResult<T> {
        
        var api: String = ""
        var url: URL
        
        if let pathParameters = pathParameters {
            api = endpoint.addPathParameters(parameters: pathParameters)
        }
        
        guard let rawUrl = URL(string: api) else {
            throw ApiError.invalidURL
        }
        
        url = rawUrl
        
        if let queryParameters = queryParameters {
            url = addQueryParameters(to: url, from: queryParameters)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        do {
            return try await performCall(with: request)
        } catch {
            throw error
        }
    }
    
    func downloadImage(endpoint: String) async throws -> Data {
        guard let url = URL(string: endpoint) else {
            throw ApiError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.invalidResponse(statusCode: -1)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw ApiError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        
        return data
    }
    
    private func performCall<T: Codable>(with request: URLRequest) async throws -> CallResult<T> {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiError.invalidResponse(statusCode: -1)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw ApiError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        
        let headers = httpResponse.allHeaderFields
        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
        
        let result = CallResult(
            response: decodedResponse,
            headers: headers)

        return result
    }
    
    private func addQueryParameters(to url: URL, from dictionary: [String:String]) -> URL {
        var queryItems: [URLQueryItem] = []
        
        dictionary.forEach({ queryItems.append(URLQueryItem(name: $0.key, value: $0.value)) })
        
        return url.appending(queryItems: queryItems)
    }
}

struct CallResult<T:Codable> {
    var response: T
    var headers: [AnyHashable: Any]
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ApiError: Error {
    case invalidResponse(statusCode: Int)
    case invalidURL
    case decodingError(error: String)
     
    var localizedDescription: String {
        switch self {
        case .invalidResponse(let statusCode): return .invalidResponse(with: String(describing: statusCode))
        case .invalidURL: return .invalidURLError
        case .decodingError(let error): return .decodingError(with: error)
        }
    }
}
