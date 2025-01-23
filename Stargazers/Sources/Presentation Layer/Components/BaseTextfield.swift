//
//  TextfieldCell.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 18/01/25.
//

import Foundation
import UIKit

final class BaseTextfield: UIView {
    
    var isRequired: Bool = false
    
//    private lazy var VStackView: UIStackView = {
//        let stackView: UIStackView = UIStackView(frame: .zero)
//        
//        stackView.axis = .vertical
//        stackView.distribution = .fillProportionally
//        stackView.spacing = 10.0
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.alignment = .fill
//        
//        return stackView
//    }()
    
    private lazy var textFieldView: UITextField = {
        let textField: UITextField = UITextField(frame: .zero)
    
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.font = UIFont(name: "Poppins-Regular", size: 15.0)
        textField.alpha = 0.65
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.textColor = .orange
        label.font = UIFont(name: "Poppins-Regular", size: 14.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.font = UIFont(name: "Poppins-Bold", size: 18.0)
        label.textColor = .white
        label.alpha = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private func setupConstraints() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        
        self.addSubview(titleLabel)
        self.addSubview(textFieldView)
        self.addSubview(errorLabel)
        
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40.0),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30.0),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0),
            
            textFieldView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10.0),
            textFieldView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30.0),
            textFieldView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30.0),
            
            errorLabel.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 5.0),
            errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 35.0),
            errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30.0),
            errorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0),
            
            textFieldView.heightAnchor.constraint(equalToConstant: 40),
            
        ])
        
    }
    
    func getValue() -> String? {
        return textFieldView.text
    }
    
    func clearValues() {
        textFieldView.text = nil
    }
    
    func reloadErrors(visible: Bool) {
        if visible {
            errorLabel.alpha = 0.65
        } else {
            errorLabel.alpha = 0
        }
    }
    
    func configure(with configuration: TextfieldConfiguration) {
        
        setupConstraints()
        
        titleLabel.text = configuration.title
        
        if let value = configuration.value {
            textFieldView.text = value
        }
        
        if let placeHolder = configuration.placeholder {
            if configuration.required {
                configurePlaceholder(placeHolder + "*")
                isRequired = true
            } else {
                configurePlaceholder(placeHolder)
            }
        }
        
        if let errorText = configuration.errorText {
            errorLabel.text = errorText
        }
    }
    
    private func configurePlaceholder(_ text: String) {
        textFieldView.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.gray.withAlphaComponent(1)
            ]
        )
    }
    
}

struct TextfieldConfiguration {
    var title: String
    var value: String?
    var placeholder: String?
    var errorText: String?
    var required: Bool
    
    init(title: String,
         value: String? = nil,
         placeholder: String? = nil,
         errorText: String? = nil,
         required: Bool = false) {
        self.title = title
        self.value = value
        self.placeholder = placeholder
        self.errorText = errorText
        self.required = required
    }
}
