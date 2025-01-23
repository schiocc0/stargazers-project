//
//  UsersListView.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 21/01/25.
//

import Foundation
import UIKit
import Combine

final class UsersListView: UIViewController, BaseView {
    typealias ViewModel = UsersListViewModel
    
    var viewModel: UsersListViewModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func configure(with viewModel: any BaseViewModel) {
        self.viewModel = viewModel as? UsersListViewModel
    }
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: .zero)
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .blue
        return activityIndicator
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        view.addSubview(activityIndicator)

        setupNavigationBar()
        setupConstraints()
        bind()
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        viewModel.$dataSource
            .sink { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        .store(in: &cancellables)
        
        viewModel.$status
            .sink { [weak self] status in
                guard let self = self else { return }
                switch status {
                case .loading:
                    showLoader()
                case .finished(let error):
                    hideLoader()
                    if let error = error {
                        showAlert(title: .errorTitle, message: error.message)
                    }
                }
            }
        .store(in: &cancellables)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        self.title = .userListTitle
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func showLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }

    private func hideLoader() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let viewModel = self.viewModel else { return }
            if viewModel.dataSource.isEmpty {
                self.navigationController?.popViewController(animated: true)
            }
        })
        alert.addAction(alertAction)
        
        DispatchQueue.main.async{
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UsersListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        cell.config(with: viewModel.dataSource[indexPath.row])
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        if indexPath.row == viewModel.dataSource.count - 2 {
            viewModel.fetchMoreData()
        }
    }
}
