//
//  EnterEmailWorker.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation

protocol VerifyEmailWorkerLogic {
    func verifyCode(code: String,
                    email: String,
                    completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    )
    
    func resendCode(
        email: String,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    )
}

final class VerifyEmailWorker: VerifyEmailWorkerLogic {
    
    @InjectSingleton
    var networkService: NetworkServiceProtocol
    
    func verifyCode(code: String,
                    email: String,
                    completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void) {
        let endpoint = "/auth/verify-code"
        let body: [String: Any] = [
            "code": code,
            "email": email
        ]
        
        networkService.request(
            endpoint: endpoint,
            method: .post,
            queryItems: nil,
            body: body,
            shouldCache: true
        ) { (result: Result<BaseServerResponse, NetworkError>) in
            switch result {
            case .success(let baseResponse):
                completion(.success(baseResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func resendCode(email: String, completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void) {
        let endpoint = "/auth/send-code"
        let body: [String: Any] = ["email": email]
        
        networkService.request(
            endpoint: endpoint,
            method: .post,
            queryItems: nil,
            body: body,
            shouldCache: true
        ) { (result: Result<BaseServerResponse, NetworkError>) in
            switch result {
            case .success(let baseResponse):
                completion(.success(baseResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
