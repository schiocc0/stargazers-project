//
//  HomeConfiguration.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 19/01/25.
//

import Foundation
import UIKit

class HomeConfiguration {
    
    var logo: UIImage
    var backgroundImage: UIImage
    var formConfiguration: FormConfiguration
    
    init(logo: UIImage, backgroundImage: UIImage, formConfiguration: FormConfiguration) {
        self.logo = logo
        self.backgroundImage = backgroundImage
        self.formConfiguration = formConfiguration
    }
    
    struct FormConfiguration {
        var ownerTextfield: TextfieldType
        var repositoryTextfield: TextfieldType
        var buttonConfiguration: DoubleButtonConfiguration
    }
    
    enum TextfieldType {
        case owner
        case repository
        
        var title: String {
            switch self {
            case .owner: return .ownerTitle
            case .repository: return .repoTitle
            }
        }
        
        var placeholder: String {
            switch self {
            case .owner: return .ownerPlaceholder
            case .repository: return .repoPlaceholder
            }
        }
        
        var error: String {
            switch self {
            case .owner: return .requiredFieldError
            case .repository: return .requiredFieldError
            }
        }
        
        var required: Bool {
            switch self {
            case .owner: return true
            case .repository: return true
            }
        }
    }
}
