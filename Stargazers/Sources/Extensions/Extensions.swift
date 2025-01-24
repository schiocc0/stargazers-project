//
//  ApiUtility.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 19/01/25.
//

import Foundation

extension String {
    
    func addPathParameters(parameters: [String:String]) -> String {
        var modifiedString = self

        parameters.forEach({ parameter in
            let placeholder = "\\{\(parameter.key)\\}"
            do {
                let regex = try NSRegularExpression(pattern: placeholder)

                modifiedString = regex.stringByReplacingMatches(
                    in: modifiedString,
                    range: NSRange(modifiedString.startIndex..., in: modifiedString),
                    withTemplate: parameter.value)
            } catch {
                print("Invalid regex: \(error.localizedDescription)")
            }
        })
        return modifiedString
    }
    
}
