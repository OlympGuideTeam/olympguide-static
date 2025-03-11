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
    
    func signUp(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        secondName: String,
        birthday: String,
        regionId: Int,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    ) {
        let endpoint = "/auth/sign-up"
        
        let body: [String: Any] = [
            "email": email,
            "password" : password,
            "first_name" : firstName,
            "last_name" : lastName,
            "second_name": secondName,
            "birthday" : birthday,
            "region_id": regionId
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
}
