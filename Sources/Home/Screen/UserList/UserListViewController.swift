//
//  File.swift
//  HomeFeature
//
//  Created by partnertientm2 on 4/11/25.
//

import UIKit
import Core
import Shared
import SnapKit
import Kingfisher
import Domain

final class UserListViewController: BaseViewController<UserListViewModelType> {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UserCell.self, forCellReuseIdentifier: UserCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.input.fetchData()
    }
    
    override func setupView() {
        title = "User List"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func bindViewModel() {
        viewModel.output.getUsersPublisher
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.tableView.reloadData()
                case .failure(let error):
                    Log.error(error.errorDescription ?? "")
                }
            }
            .store(in: &cancellables)
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.output.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        cell.configure(with: viewModel.output.users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let username = viewModel.output.users[indexPath.row].login
        let vc = HomeFeature().makeUserdetailViewController(username: username)
        navigationController?.pushViewController(vc, animated: true)
    }
}
