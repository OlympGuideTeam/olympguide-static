//
//  PersonalDataWorker.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

import Foundation

final class PersonalDataWorker {
    @InjectSingleton
    var networkService: NetworkServiceProtocol
    
    func updateProfile(
        firstName: String,
        lastName: String,
        secondName: String,
        birthday: String,
        regionId: Int,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    ) {
        let endpoint = "/user/update"
        
        let body: [String: Any] = [
            "first_name" : firstName,
            "last_name" : lastName,
            "second_name": secondName,
            "birthdate" : birthday,
            "region_id": regionId
        ]
        
        networkService.request(
            endpoint: endpoint,
            method: .post,
            queryItems: nil,
            body: body,
            shouldCache: false
        ) { [weak self] (result: Result<BaseServerResponse, NetworkError>) in
            switch result {
            case .success(let baseResponse):
                self?.networkService.request(
                    endpoint: "/user/diplomas/sync",
                    method: .post,
                    queryItems: nil,
                    body: nil,
                    shouldCache: false
                ) { (result: Result<BaseServerResponse, NetworkError>) in }
                completion(.success(baseResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
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
