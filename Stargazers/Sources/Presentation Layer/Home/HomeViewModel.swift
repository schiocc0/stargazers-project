//
//  HomeViewModel.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 18/01/25.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func homeViewModelDidAskToNavigate(_ homeViewModel: HomeViewModel, with ownerName: String, and repositoryName: String)
}

final class HomeViewModel: BaseViewModel {
    var coordinator: Coordinator?
    weak var delegate: HomeViewModelDelegate?
    
    var configuration: HomeConfiguration
    
    init(coordinator: Coordinator? = nil, delegate: HomeViewModelDelegate, configuration: HomeConfiguration) {
        self.coordinator = coordinator
        self.delegate = delegate
        self.configuration = configuration
    }
    
    func search(with ownerName: String, and repositoryName: String) {
        self.delegate?.homeViewModelDidAskToNavigate(self, with: ownerName, and:  repositoryName)
    }
}
