//
//  Worker.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import Foundation

protocol EnterPasswordWorkerLogic {
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    )
}

class EnterPasswordWorker : EnterPasswordWorkerLogic {
    @InjectSingleton
    var networkService: NetworkServiceProtocol
    
    let token: String
    
    init(token: String) {
        self.token = token
    }
    
    
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    ) {
        let body: [String: Any] = [
            "email": email,
            "password" : password
        ]
        
        networkService.requestWithBearer(
            endpoint: "/auth/sign-up",
            method: .post,
            queryItems: nil,
            body: body,
            bearerToken: token,
            shouldCache: false
        ) { (result: Result<BaseServerResponse, NetworkError>) in
            switch result {
            case .success(let olympiads):
                completion(.success(olympiads))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
