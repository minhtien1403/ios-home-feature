//
//  File.swift
//  HomeFeature
//
//  Created by partnertientm2 on 4/11/25.
//

import UIKit
import Core
import Shared
import Domain
import Data

public final class HomeFeature: HomeFeatureInterface {
    
    public init() {
        
    }
    
    public func makeUserListViewController() -> UIViewController {
        UserListViewController(
            viewModel: UserListViewModel(
                usecase: UserUsecaseImpl(repository: UserRepositoryImpl()),
                users: []
            )
        )
    }
    
    public func makeUserdetailViewController(username: String) -> UIViewController {
        UserDetailsViewController(
            viewModel: UserDetailsViewModel(
                usecase: UserUsecaseImpl(repository: UserRepositoryImpl()),
                username: username
            )
        )
    }
}

extension HomeFeature: DeepLinkHandler {
    
    public func canHandle(_ link: DeepLink) -> Bool {
        link.path.hasPrefix("/home")
    }
    
    public func viewController(for link: DeepLink) -> UIViewController? {
        switch true {
        // Danh sách user
        case link.path == "/home/users":
            Log.context()
            return makeUserListViewController()
            
        // Chi tiết user: /home/user/{username}
        case link.path.hasPrefix("/home/user/"):
            Log.context()
            // Cắt phần username ra
            let username = link.path.replacingOccurrences(of: "/home/user/", with: "")
            guard !username.isEmpty else { return nil }
            return makeUserdetailViewController(username: username)
            
        default:
            return nil
        }
    }
}
