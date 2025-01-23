//
//  BaseViewModel.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 18/01/25.
//

import Foundation

protocol BaseViewModel: AnyObject {
    
    var coordinator: Coordinator? { get set }

}
