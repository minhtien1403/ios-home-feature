//
//  File.swift
//  HomeFeature
//
//  Created by partnertientm2 on 7/11/25.
//

import UIKit
import Core
import Combine
import Domain
import Shared

final class UserDetailsViewController: BaseViewController<UserDetailsViewModelType> {
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let avatarImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let locationLabel = UILabel()
    
    private let followersView = InfoView()
    private let followingView = InfoView()
    
    private let blogTitleLabel = UILabel()
    private let blogLinkLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.fetchUserDetails()
    }
    
    override func setupView() {
        view.backgroundColor = .systemBackground
        title = "User Details"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.layer.masksToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        contentView.addSubview(avatarImageView)
        
        usernameLabel.font = .boldSystemFont(ofSize: 22)
        usernameLabel.textAlignment = .center
        contentView.addSubview(usernameLabel)
        
        locationLabel.font = .systemFont(ofSize: 16)
        locationLabel.textColor = .gray
        locationLabel.textAlignment = .center
        contentView.addSubview(locationLabel)
        
        followersView.configure(icon: "person.2", title: "Follower")
        followingView.configure(icon: "rosette", title: "Following")
        contentView.addSubview(followersView)
        contentView.addSubview(followingView)
        
        blogTitleLabel.text = "Blog"
        blogTitleLabel.font = .boldSystemFont(ofSize: 18)
        contentView.addSubview(blogTitleLabel)
        
        blogLinkLabel.font = .systemFont(ofSize: 15)
        blogLinkLabel.textColor = .systemBlue
        blogLinkLabel.numberOfLines = 0
        contentView.addSubview(blogLinkLabel)
        setupLayout()
    }
    
    func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        followersView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(40)
        }
        
        followingView.snp.makeConstraints { make in
            make.centerY.equalTo(followersView)
            make.right.equalToSuperview().offset(-40)
        }
        
        blogTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(followersView.snp.bottom).offset(25)
            make.left.equalToSuperview().offset(20)
        }
        
        blogLinkLabel.snp.makeConstraints { make in
            make.top.equalTo(blogTitleLabel.snp.bottom).offset(6)
            make.left.equalTo(blogTitleLabel)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    // MARK: - Bind
    
    override func bindViewModel() {
        viewModel.output.getUserDetailsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let user):
                    self.updateUI(with: user)
                case .failure(let error):
                    Log.error(error.errorDescription ?? "")
                }
            }
            .store(in: &cancellables)
        viewModel.input.fetchUserDetails()
    }
    
    func updateUI(with user: UserDetails) {
        usernameLabel.text = user.login
        locationLabel.text = user.location ?? "Unknown"
        followersView.setCount(user.followers)
        followingView.setCount(user.following)
        blogLinkLabel.text = user.blog
        if let url = URL(string: user.avatarURL) {
            avatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.circle"),
                options: [.transition(.fade(0.3))]
            )
        }
    }
}

// MARK: - InfoView (Follower / Following)
final class InfoView: UIView {
    private let iconImageView = UIImageView()
    private let countLabel = UILabel()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        iconImageView.tintColor = .label
        addSubview(iconImageView)
        
        countLabel.font = .boldSystemFont(ofSize: 18)
        countLabel.textAlignment = .center
        addSubview(countLabel)
        
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }
    
    private func setupLayout() {
        iconImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(30)
        }
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(icon: String, title: String) {
        iconImageView.image = UIImage(systemName: icon)
        titleLabel.text = title
    }
    
    func setCount(_ count: Int) {
        countLabel.text = "\(count)"
    }
}
