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
        token: String,
        password: String,
        firstName: String,
        lastName: String,
        secondName: String,
        birthday: String,
        regionId: Int,
        isGoogleSignUp: Bool,
        completion: @escaping (Result<BaseServerResponse, NetworkError>) -> Void
    ) {
        let endpoint = isGoogleSignUp ? "/auth/complete-sign-up" : "/auth/sign-up"
        
        let body: [String: Any] = [
            "password" : password,
            "first_name" : firstName,
            "last_name" : lastName,
            "second_name": secondName,
            "birthday" : birthday,
            "region_id": regionId
        ]
        
        networkService.requestWithBearer(
            endpoint: endpoint,
            method: .post,
            queryItems: nil,
            body: body,
            bearerToken: token,
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
