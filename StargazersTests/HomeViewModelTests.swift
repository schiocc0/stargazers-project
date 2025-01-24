//
//  HomeViewModelTests.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 24/01/25.
//

import XCTest
@testable import Stargazers

class HomeViewModelTests: XCTestCase {
    
    func test_search() {
        //Given
        let mockDelegate = MockDelegate()
        let mockCoordinator = MockCoordinator(navigationController: UINavigationController())
        let configuration = HomeConfiguration(
            logo: UIImage(),
            backgroundImage: UIImage(),
            formConfiguration: HomeConfiguration.FormConfiguration(
                ownerTextfield: .owner,
                repositoryTextfield: .repository,
                buttonConfiguration: DoubleButtonConfiguration(topButtonTitle: "Test")))
        let ownerName = "TestOwner"
        let repositoryName = "TestRepo"
        
        let viewModel = HomeViewModel(coordinator: mockCoordinator, delegate: mockDelegate, configuration: configuration)
        
        //When
        viewModel.search(with: ownerName, and: repositoryName)
        
        //Then
        XCTAssertTrue(mockDelegate.didAskToNavigate, "Delegate's `homeViewModelDidAskToNavigate` should have been called.")
        XCTAssertEqual(mockDelegate.receivedOwnerName, ownerName, "Delegate should have received the correct owner name.")
        XCTAssertEqual(mockDelegate.receivedRepoName, repositoryName, "Delegate should have received the correct repository name.")
    }
}

extension HomeViewModelTests {
    class MockCoordinator: Coordinator {
        var navigationController: UINavigationController
        var fatherCoordinator: (any Stargazers.Coordinator)?
        var childCoordinato: (any Stargazers.Coordinator)?
        
        func start() {}
        
        init(navigationController: UINavigationController, fatherCoordinator: (any Stargazers.Coordinator)? = nil, childCoordinato: (any Stargazers.Coordinator)? = nil) {
            self.navigationController = navigationController
            self.fatherCoordinator = fatherCoordinator
            self.childCoordinato = childCoordinato
        }
    }
    
    class MockDelegate: HomeViewModelDelegate {
        var didAskToNavigate = false
        var receivedOwnerName: String?
        var receivedRepoName: String?
        
        func homeViewModelDidAskToNavigate(_ homeViewModel: HomeViewModel, with ownerName: String, and repositoryName: String) {
            didAskToNavigate = true
            receivedOwnerName = ownerName
            receivedRepoName = repositoryName
        }
    }
}
