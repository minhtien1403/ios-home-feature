//
//  File.swift
//  HomeFeature
//
//  Created by partnertientm2 on 7/11/25.
//

import Foundation
import Core
import Combine
import Domain

public protocol UserDetailsViewModelInputType {
    
    func fetchUserDetails()
}

public protocol UserDetailsViewModelOutputType {
    
    var getUserDetailsPublisher: AnyPublisher<Result<UserDetails, APIError>, Never> { get }
}

public protocol UserDetailsViewModelType {
    
    var input: UserDetailsViewModelInputType { get }
    var output: UserDetailsViewModelOutputType { get }
}

final class UserDetailsViewModel: BaseViewModel {
    
    var username: String
    private let usecase: GetUserDetailsUsecase
    private let getUserDetailsSubject = PassthroughSubject<Result<UserDetails, APIError>, Never>()
    
    init(usecase: GetUserDetailsUsecase, username: String) {
        self.usecase = usecase
        self.username = username
    }
}

extension UserDetailsViewModel: UserDetailsViewModelType {
    
    var input: any UserDetailsViewModelInputType {
        self
    }
    
    var output: any UserDetailsViewModelOutputType {
        self
    }
}

extension UserDetailsViewModel: UserDetailsViewModelInputType {
    
    func fetchUserDetails() {
        usecase.getUserDetails(username: username)
            .sink { [weak self] result in
                switch result {
                case .success(let userDetails):
                    self?.getUserDetailsSubject.send(.success(userDetails))
                case .failure(let error):
                    self?.getUserDetailsSubject.send(.failure(error))
                }
            }
            .store(in: &cancellables)
    }
}

extension UserDetailsViewModel: UserDetailsViewModelOutputType {
    
    var getUserDetailsPublisher: AnyPublisher<Result<UserDetails, APIError>, Never> {
        getUserDetailsSubject.eraseToAnyPublisher()
    }
}
