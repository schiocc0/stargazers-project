//
//  HomeView.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 18/01/25.
//

import UIKit
import Foundation
import Combine

final class HomeView: UIViewController, BaseView {
    typealias ViewModel = HomeViewModel
    
    var viewModel: HomeViewModel? = nil
    
    private var ownerTextField = BaseTextfield()
    private var repoTextField = BaseTextfield()
    private var doubleButton = DoubleButtonView()
    
    func configure(with viewModel: any BaseViewModel) {
        self.viewModel = viewModel as? HomeViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupBackground()
        setupViews()
    }

    private func setupBackground() {
        let backgroundImageView = UIImageView(frame: self.view.bounds)
        backgroundImageView.image = .gradientBackground
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(backgroundImageView, at: 0)
        
        NSLayoutConstraint.activate([
            // Background image constraints
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupViews() {
        guard let viewModel = viewModel else { return }
        
        let stackView = createForm()
        let logoView = createLogoView()
        
        let configuration = viewModel.configuration.formConfiguration
        
        ownerTextField = createTextFields(type: configuration.ownerTextfield)
        repoTextField = createTextFields(type: configuration.repositoryTextfield)
        doubleButton = createButtonView()
        
        stackView.addArrangedSubview(ownerTextField)
        stackView.addArrangedSubview(repoTextField)
        
        self.view.addSubview(logoView)
        self.view.addSubview(stackView)
        self.view.addSubview(doubleButton)
        
        NSLayoutConstraint.activate([
            // Logo view constraints
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0),
            logoView.heightAnchor.constraint(equalToConstant: 200),
            logoView.widthAnchor.constraint(equalToConstant: 200),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // StackView constraints
            stackView.topAnchor.constraint(greaterThanOrEqualTo: logoView.bottomAnchor, constant: 20.0),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Button constraints
            doubleButton.topAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor, constant: 40.0),
            doubleButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -100.0),
            doubleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            doubleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            doubleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func createLogoView() -> UIImageView {
        let logoView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 40.0, height: 40.0)))
        logoView.image = .stargazersIcon
        logoView.translatesAutoresizingMaskIntoConstraints = false
        return logoView
    }
    
    private func createForm() -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 20.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func createTextFields(type: HomeConfiguration.TextfieldType) -> BaseTextfield {
        let texfield = BaseTextfield()
        let configuration = TextfieldConfiguration(
            title: type.title,
            placeholder: type.placeholder,
            errorText: .requiredFieldError,
            required: type.required)
        texfield.configure(with: configuration)
        return texfield
    }
    
    private func createButtonView() -> DoubleButtonView {
        let button = DoubleButtonView()
        let configuration = DoubleButtonConfiguration(
            delegate: self,
            topButtonTitle: .searchButton,
            bottomButtonTitle: .clearButton)
        button.configure(configuration: configuration)
        return button
    }
    
    private func validate() {
        guard let viewModel = viewModel else { return }
        var isValid: Bool = true
        
        if ownerTextField.isRequired {
            isValid = validateRequiredTextField(ownerTextField)
        }
        if repoTextField.isRequired {
            isValid = validateRequiredTextField(repoTextField)
        }
        
        if isValid {
            doubleButton.reloadButtonState(enabled: true)
            viewModel.search(with: ownerTextField.getValue() ?? "", and: repoTextField.getValue() ?? "")
        } else {
            doubleButton.reloadButtonState(enabled: false)
        }
    }
    
    private func validateRequiredTextField(_ textfield: BaseTextfield) -> Bool {
        var isValid = true
        if let text = textfield.getValue(), text.isEmpty ||
            textfield.getValue() == nil
        {
            isValid = false
            textfield.reloadErrors(visible: true)
        } else {
            textfield.reloadErrors(visible: false)
        }
        return isValid
    }
    
    private func clearForm() {
        ownerTextField.clearValues()
        repoTextField.clearValues()
    }
}

extension HomeView: DoubleButtonViewDelegate {
    func topButtonViewSelected() {
        self.validate()
    }
    
    func bottomButtonViewSelected() {
        self.clearForm()
    }
}
