//
//  StargazersAPI.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 19/01/25.
//

import Foundation
import UIKit

final class StargazersAPI {
    
    static var path: String = "https://api.github.com/repos/{owner}/{repo}/stargazers"
            
    struct User: Decodable {
        let login: String
        let avatarURL: String
        
        enum CodingKeys: String, CodingKey {
            case login
            case avatarURL = "avatar_url"
        }
    }
    
    enum PathParameters: String {
        case owner
        case repo
    }
    
    enum QueryParameters: String {
        case per_page
        case page
    }
}

enum FetchError: Error {
    case invalidResponse(statusCode: Int)
    case invalidURL
    case decodingError
    
    var message: String {
        switch self {
        case .invalidResponse(let statusCode): return "Invalid response\n(Error: \(String(describing: statusCode)))"
        case .invalidURL: return "URL is not valid"
        case .decodingError: return "Error in decoding data"
        }
    }
}
