//
//  FieldWorker.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import Foundation

protocol FieldWorkerLogic {
    func fetchPrograms(
        for fieldId: Int,
        with params: [Param],
        completion: @escaping (Result<[ProgramsByUniversityModel]?, Error>) -> Void
    )
}

class FieldWorker : FieldWorkerLogic {
    
    @InjectSingleton
    var networkService: NetworkServiceProtocol
    
    func fetchPrograms(
        for fieldId: Int,
        with params: [Param],
        completion: @escaping (Result<[ProgramsByUniversityModel]?, Error>) -> Void
    ) {
        var queryItems = [URLQueryItem]()
        for param in params {
            queryItems.append(param.urlValue)
        }
        networkService.request(
            endpoint: "/field/\(fieldId)/programs",
            method: .get,
            queryItems: queryItems,
            body: nil,
            shouldCache: true
        ) { (result: Result<[ProgramsByUniversityModel]?, NetworkError>) in
            switch result {
            case .success(let programs):
                completion(.success(programs))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
