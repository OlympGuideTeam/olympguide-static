//
//  GenericSearchWorker.swift
//  olympguide
//
//  Created by Tom Tim on 03.03.2025.
//

import Combine
import Foundation

final class GenericSearchWorker<Strategy: SearchStrategy> {
    typealias ResponseType = Strategy.ResponseType
    @InjectSingleton
    var networkService: NetworkServiceProtocol
    private let strategy: Strategy
    private let transform: ([ResponseType]) -> [Strategy.ModelType]
    private let endpoint: String
    init(
        strategy: Strategy,
        endpoint: String
    ){
        self.strategy = strategy
        self.endpoint = endpoint
        self.transform = strategy.responseTypeToModel
    }
    
    func search(query: String) -> AnyPublisher<[Strategy.ModelType], Never> {
        let queryItems: [URLQueryItem] = strategy.queryItems(for: query)
        
        return Future<[Strategy.ModelType], Never> { promise in
            self.networkService.request(
                endpoint: self.endpoint,
                method: .get,
                queryItems: queryItems,
                body: nil,
                shouldCache: true
            ) { (result: Result<[ResponseType], NetworkError>) in
                switch result {
                case .success(let response):
                    let models = self.transform(response)
                    promise(.success(models))
                case .failure(let error):
                    print("Search error: \(error)")
                    promise(.success([]))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
