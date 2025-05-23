//
//  UniversityWorker.swift
//  olympguide
//
//  Created by Tom Tim on 23.12.2024.
//

import Foundation

protocol UniversitiesWorkerLogic {
    func fetchUniversities(
        with params: [Param],
        completion: @escaping (Result<[UniversityModel]?, Error>) -> Void
    )
}


final class UniversitiesWorker : UniversitiesWorkerLogic {
    @InjectSingleton
    var networkService: NetworkServiceProtocol

    func fetchUniversities(
        with params: [Param],
        completion: @escaping (Result<[UniversityModel]?, Error>) -> Void
    ) {
        var queryItems = [URLQueryItem]()
        
        for param in params {
            queryItems.append(param.urlValue)
        }
        
        networkService.request(
            endpoint: "/universities",
            method: .get,
            queryItems: queryItems,
            body: nil,
            shouldCache: true
        ) { (result: Result<[UniversityModel]?, NetworkError>) in
            switch result {
            case .success(let universities):
                completion(.success(universities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
