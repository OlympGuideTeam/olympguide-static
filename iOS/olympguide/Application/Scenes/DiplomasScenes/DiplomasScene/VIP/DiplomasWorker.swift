//
//  DiplomasWorker.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import Foundation

protocol DiplomasWorkerLogic {
    func fetchDiplomas(
        completion: @escaping (Result<[DiplomaModel], Error>) -> Void
    )
    
    func deleteDiploma(
        id: Int,
        completion: @escaping (Result<BaseServerResponse, Error>) -> Void
    )
    
    func syncDiplomas(
        completion: @escaping (Result<BaseServerResponse, Error>) -> Void
    )
}

class DiplomasWorker : DiplomasWorkerLogic {
    @InjectSingleton
    var networkService: NetworkServiceProtocol
    
    func fetchDiplomas(
        completion: @escaping (Result<[DiplomaModel], Error>) -> Void
    ) {
        networkService.request(
            endpoint: "/user/diplomas",
            method: .get,
            queryItems: nil,
            body: nil,
            shouldCache: false
        ) { (result: Result<[DiplomaModel], NetworkError>) in
            switch result {
            case .success(let olympiads):
                completion(.success(olympiads))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteDiploma(
        id: Int,
        completion: @escaping (Result<BaseServerResponse, any Error>) -> Void
    ) {
        networkService.request(
            endpoint: "/user/diploma/\(id)",
            method: .delete,
            queryItems: nil,
            body: nil,
            shouldCache: false
        ) { (result: Result<BaseServerResponse, NetworkError>) in
            switch result {
            case .success(let baseResponse):
                completion(.success(baseResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func syncDiplomas(
        completion: @escaping (Result<BaseServerResponse, any Error>) -> Void
    ) {
        networkService.request(
            endpoint: "/user/diplomas/sync",
            method: .post,
            queryItems: nil,
            body: nil,
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
