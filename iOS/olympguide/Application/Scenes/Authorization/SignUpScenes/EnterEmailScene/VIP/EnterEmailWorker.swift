//
//  EnterEmailWorker.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation

protocol EnterEmailWorkerLogic {
    func sendCode(
        email: String,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    )
}

final class EnterEmailWorker: EnterEmailWorkerLogic {
    @InjectSingleton
    var networkService: NetworkServiceProtocol
    
    func sendCode(
        email: String,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    ) {
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
