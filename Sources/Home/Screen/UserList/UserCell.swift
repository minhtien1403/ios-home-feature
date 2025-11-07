//
//  File.swift
//  HomeFeature
//
//  Created by partnertientm2 on 7/11/25.
//

import UIKit
import SnapKit
import Kingfisher
import Domain

final class UserCell: UITableViewCell {
    static let identifier = "UserCell"
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with user: User) {
        nameLabel.text = user.login
        
        if let url = URL(string: user.avatarURL) {
            avatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.circle"),
                options: [.transition(.fade(0.2))]
            )
        } else {
            avatarImageView.image = UIImage(systemName: "person.circle")
        }
    }
}

