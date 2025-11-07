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

public final class HomeFeature: HomeFeatureInterface {
    
    public func makeUserListViewController() -> UIViewController {
        UserListViewController(viewModel: UserListViewModel(usecase: GetListUserUsecaseImpl(), users: []))
    }
    
    public func makeUserdetailViewController(username: String) -> UIViewController {
        UserDetailsViewController(viewModel: UserDetailsViewModel(usecase: GetUserDetailsUsecaseImpl(), username: username))
    }
}
