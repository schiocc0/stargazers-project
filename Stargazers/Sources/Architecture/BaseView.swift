//
//  BaseView.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 18/01/25.
//

import Foundation

protocol BaseView: AnyObject {
    associatedtype ViewModel: BaseViewModel
    var viewModel: ViewModel? { get set }
    
    func configure(with viewModel: BaseViewModel)
    
}
