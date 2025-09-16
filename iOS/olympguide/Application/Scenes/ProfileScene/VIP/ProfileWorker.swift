//
//  ProfileWorker.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 23.04.2025.
//

import Foundation

protocol ProfileWorkerLogic {
    func fetchUser(
        completion: @escaping (Result<UserModel, NetworkError>) -> Void
    )
}

final class ProfileWorker: ProfileWorkerLogic {
    @InjectSingleton
    var networkService: NetworkServiceProtocol
    
    func fetchUser(
        completion: @escaping (Result<UserModel, NetworkError>) -> Void
    ) {
        networkService.request(
            endpoint: "/user/data",
            method: .get,
            queryItems: nil,
            body: nil,
            shouldCache: false
        ) { (result: Result<UserModel, NetworkError>) in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
