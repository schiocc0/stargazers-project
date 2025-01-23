//
//  Coordinator.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 18/01/25.
//

import UIKit

protocol Coordinator: AnyObject {
    /// The navigation controller for the coordinator
    var navigationController: UINavigationController { get set }
    
    var fatherCoordinator: Coordinator? { get set }
    
    var childCoordinato: Coordinator? { get set }
    
    func start()
}
