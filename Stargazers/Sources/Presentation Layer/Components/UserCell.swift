//
//  UserCell.swift
//  Stargazers
//
//  Created by Alessia Carrozzo on 21/01/25.
//

import Foundation
import UIKit

final class UserCell: UITableViewCell {
    
    private lazy var userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25 // Per ottenere un cerchio
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var userId: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(userImage)
        contentView.addSubview(userId)
        
        // Configura le constraints
        NSLayoutConstraint.activate([
            // Constraints per l'immagine
            userImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            userImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImage.widthAnchor.constraint(equalToConstant: 50),
            userImage.heightAnchor.constraint(equalToConstant: 50),
            userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5.0),
            userImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
            
            // Constraints per l'etichetta
            userId.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 16),
            userId.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            userId.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func config(with configuration: UserCellConfiguration) {
        self.userId.text = configuration.userId
        self.userImage.image = configuration.userImage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct UserCellConfiguration {
    var userId: String
    var userImage: UIImage
    
    init(userId: String, userImage: UIImage) {
        self.userId = userId
        self.userImage = userImage
    }
}
