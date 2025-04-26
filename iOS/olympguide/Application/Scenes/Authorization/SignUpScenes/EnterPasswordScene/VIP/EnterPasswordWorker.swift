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
    let isPasswordChange: Bool
    init(token: String, isPasswordChange: Bool) {
        self.token = token
        self.isPasswordChange = isPasswordChange
    }
    
    
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    ) {
        let body: [String: Any] = isPasswordChange ? [ "password" : password ] :
        [ "email": email, "password" : password]
        
        networkService.requestWithBearer(
            endpoint: isPasswordChange ? "/user/update-password" : "/auth/sign-up",
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
