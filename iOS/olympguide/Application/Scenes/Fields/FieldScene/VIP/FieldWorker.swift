//
//  FieldWorker.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import Foundation

protocol FieldWorkerLogic {
    func fetch(
        with params: Dictionary<String, Set<String>>,
        completion: @escaping (Result<[ProgramModel], Error>) -> Void
    )
}

class FieldWorker : FieldWorkerLogic {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetch(
        with params: Dictionary<String, Set<String>>,
        completion: @escaping (Result<[ProgramModel], Error>) -> Void
    ) {
        var queryItems = [URLQueryItem]()
        
        networkService.request(
            endpoint: "",
            method: .get,
            queryItems: queryItems,
            body: nil
        ) { (result: Result<[ProgramModel], NetworkError>) in
            switch result {
            case .success(let olympiads):
                completion(.success(olympiads))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
