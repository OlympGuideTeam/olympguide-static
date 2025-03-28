//
//  FavoriteOlympiadsWorker.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import Foundation

final class FavoriteOlympiadsWorker : OlympiadsWorkerLogic {
    @InjectSingleton
    var networkService: NetworkServiceProtocol
    
    func fetchOlympiads(
        with params: [Param] = [],
        completion: @escaping (Result<[OlympiadModel], Error>) -> Void
    ) {
        networkService.request(
            endpoint: "/user/favourite/olympiads",
            method: .get,
            queryItems: nil,
            body: nil,
            shouldCache: false
        ) { (result: Result<[OlympiadModel]?, NetworkError>) in
            switch result {
            case .success(let olympiads):
                completion(.success(olympiads ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
