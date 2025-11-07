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

public final class HomeFeatureDeepLinkHandler: DeepLinkHandler {
    
    private let homeFeature = HomeFeature()
    
    public init() {}
    
    public func canHandle(_ link: DeepLink) -> Bool {
        link.path.hasPrefix("/home")
    }
    
    public func viewController(for link: DeepLink) -> UIViewController? {
        switch true {
        // Danh sách user
        case link.path == "/home/users":
            Log.context()
            return homeFeature.makeUserListViewController()
            
        // Chi tiết user: /home/user/{username}
        case link.path.hasPrefix("/home/user/"):
            Log.context()
            // Cắt phần username ra
            let username = link.path.replacingOccurrences(of: "/home/user/", with: "")
            guard !username.isEmpty else { return nil }
            return homeFeature.makeUserdetailViewController(username: username)
            
        default:
            return nil
        }
    }

}
