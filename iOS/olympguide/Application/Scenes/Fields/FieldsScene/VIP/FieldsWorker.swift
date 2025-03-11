//
//  FieldWorker.swift
//  olympguide
//
//  Created by Tom Tim on 23.12.2024.
//

import Foundation

class FieldsWorker {
    
    private let networkService: NetworkService
    
    init() {
        self.networkService = NetworkService()
    }
    
    func fetchFields(
        with params: [Param],
        completion: @escaping (Result<[GroupOfFieldsModel], Error>) -> Void
    ) {
        var queryItems = [URLQueryItem]()
        
        for param in params {
            queryItems.append(param.urlValue)
        }

        networkService.request(
            endpoint: "/fields",
            method: .get,
            queryItems: queryItems,
            body: nil
        ) { (result: Result<[GroupOfFieldsModel], NetworkError>) in
            switch result {
            case .success(let groupsOfFieldsModel):
                completion(.success(groupsOfFieldsModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
