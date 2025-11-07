//
//  File.swift
//  UserListFeature
//
//  Created by partnertientm2 on 4/11/25.
//

import Core
import Foundation
import Combine
import Domain

public protocol UserListViewModelInputType {
    
    func fetchData()
}

public protocol UserListViewModelOutputType {
    
    var users: [User] { get }
    var getUsersPublisher: AnyPublisher<Result<Void, APIError>, Never> { get }
}

public protocol UserListViewModelType {
    
    var input: UserListViewModelInputType { get }
    var output: UserListViewModelOutputType { get }
}

final class UserListViewModel: BaseViewModel {
    
    var users: [User]
    private let usecase: GetListUserUsecase
    private let getUsersSubject = PassthroughSubject<Result<Void, APIError>, Never>()
    
    public init(usecase: GetListUserUsecase, users: [User]) {
        self.usecase = usecase
        self.users = users
    }
    
}

extension UserListViewModel: UserListViewModelType {
    
    var input: any UserListViewModelInputType { self }
    var output: any UserListViewModelOutputType { self }
}

extension UserListViewModel: UserListViewModelInputType {
    
    func fetchData() {
        usecase.getListUser(perPage: 20, since: 0)
            .sink { [weak self] result in
                switch result {
                case .success(let users):
                    self?.users = users
                case .failure(let error):
                    self?.getUsersSubject.send(.failure(error))
                }
            }
            .store(in: &cancellables)
    }
}

extension UserListViewModel: UserListViewModelOutputType {
    
    var getUsersPublisher: AnyPublisher<Result<Void, APIError>, Never> {
        getUsersSubject.eraseToAnyPublisher()
    }
}
