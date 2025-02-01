//
//  Strings.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 19/01/25.
//

import UIKit

extension String {
    
    static var ownerTitle: String = String(localized: "OWNER.FIELD.TITLE")
    static var ownerPlaceholder: String = String(localized: "OWNER.FIELD.PLACEHOLDER")
    
    static var repoTitle: String = String(localized: "REPO.FIELD.TITLE")
    static var repoPlaceholder: String = String(localized: "REPO.FIELD.PLACEHOLDER")
    
    static var searchButton = String(localized: "BUTTON.SEARCH").uppercased()
    static var clearButton = String(localized: "BUTTON.CLEAR.ALL")
    
    static var requiredFieldError = String(localized: "REQUIRED.FIELD.ERROR")
    
    static var userListTitle = String(localized: "USER.LIST.TITLE")
    
    static var errorTitle = String(localized: "ERROR.TITLE")
    static var errorText = String(localized: "ERROR.TEXT")
    static var errorButton = String(localized: "ERROR.BUTTON.OK")
    
    
    //MARK: Errors
    static var invalidURLError = String(localized: "INVALID.URL.ERROR")
    static func invalidResponse(with statusCode: String) -> String {
        return String(format: NSLocalizedString("INVALID.RESPONSE.ERROR", comment: "Error message with code"), statusCode)
    }
    static func decodingError(with reason: String) -> String {
        return String(format: NSLocalizedString("DECODING.ERROR", comment: "Error message with reason"), reason)
    }
    
}
