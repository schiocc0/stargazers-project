//
//  ApiObject.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 19/01/25.
//

import Foundation

protocol ApiObject: AnyObject {
    
    associatedtype Input: Codable
    associatedtype Output: Codable
    
    var request: Input { get }
    var response: Output { get }
    
    static var method: HTTPMethod { get }
    static var path: String { get set }
}

struct CodableVoid: Codable { }
