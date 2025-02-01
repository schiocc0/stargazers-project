//
//  DoubleButton.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 18/01/25.
//

import Foundation
import UIKit

import UIKit

protocol DoubleButtonViewDelegate: AnyObject {
    func topButtonViewSelected()
    func bottomButtonViewSelected()
}

class DoubleButtonView: UIView {
    
    private weak var delegate: DoubleButtonViewDelegate?

    private lazy var topButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont(name: "Poppins-Regular", size: 15.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var bottomLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font =  UIFont(name: "Poppins-Regular", size: 15.0)
        button.titleLabel?.textAlignment = .center
        button.setAttributedTitle(nil, for: .normal)
        button.alpha = 0.8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        // Add subviews
        addSubview(topButton)
        addSubview(bottomLinkButton)
        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Top button constraints
            topButton.topAnchor.constraint(equalTo: topAnchor),
            topButton.widthAnchor.constraint(equalToConstant: 150.0),
            topButton.heightAnchor.constraint(equalToConstant: 40),
            topButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            //Bottom button constraints
            bottomLinkButton.topAnchor.constraint(equalTo: topButton.bottomAnchor, constant: 20),
            bottomLinkButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomLinkButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Configuration
    func configure(
        configuration: DoubleButtonConfiguration
    ) {
        self.delegate = configuration.delegate
        
        // Configure top button
        topButton.setTitle(configuration.topButtonTitle.uppercased(), for: .normal)
        topButton.alpha = configuration.enabled ? 0.7 : 0.2
        setTopButtonAction(target: self, action: #selector(topButtonAction))

        // Configure bottom button (link)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black, 
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        if let bottomTitle = configuration.bottomButtonTitle {
            let attributedTitle = NSAttributedString(string: bottomTitle, attributes: attributes)
            bottomLinkButton.setAttributedTitle(attributedTitle, for: .normal)
            setBottomLinkAction(target: self, action: #selector(bottomButtonAction))
        }
    }
    
    func reloadButtonState(enabled: Bool) {
        if enabled {
            topButton.alpha = 0.7
        } else {
            topButton.alpha = 0.2
        }
    }

    // MARK: - Button Actions
    private func setTopButtonAction(target: Any, action: Selector) {
        topButton.addTarget(target, action: action, for: .touchUpInside)
    }

    private func setBottomLinkAction(target: Any, action: Selector) {
        bottomLinkButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    @objc func topButtonAction() {
        self.delegate?.topButtonViewSelected()
    }
    
    @objc func bottomButtonAction() {
        self.delegate?.bottomButtonViewSelected()
    }
}

struct DoubleButtonConfiguration {
    var delegate: DoubleButtonViewDelegate?
    var topButtonTitle: String
    var bottomButtonTitle: String?
    var enabled: Bool
    
    init(delegate: DoubleButtonViewDelegate? = nil,
         topButtonTitle: String,
         bottomButtonTitle: String? = nil,
         enabled: Bool = false) {
        self.delegate = delegate
        self.topButtonTitle = topButtonTitle
        self.bottomButtonTitle = bottomButtonTitle
        self.enabled = enabled
    }
}


