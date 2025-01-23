//
//  ApiObject.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 19/01/25.
//

import Foundation

protocol ApiObject: AnyObject {
    
    static var request: Any { get set }
    static var response: Any { get set }
    
    static var path: String { get set }
    
}
