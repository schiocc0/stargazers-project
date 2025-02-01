//
//  StargazersAPI.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 19/01/25.
//

import Foundation
import UIKit

typealias User = StargazersAPI.User

final class StargazersAPI: ApiObject {
    
    var request: CodableVoid = CodableVoid()
    var response: [User] = []
    
    static var method: HTTPMethod = .get
    
    static var path: String = "https://api.github.com/repos/{owner}/{repo}/stargazers"
            
    struct User: Codable {
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
