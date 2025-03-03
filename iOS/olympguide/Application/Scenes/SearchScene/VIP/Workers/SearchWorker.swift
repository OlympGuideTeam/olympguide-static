////
////  SearchWorker.swift
////  olympguide
////
////  Created by Tom Tim on 01.01.2025.
////
//
//import Combine
//import Foundation
//
//class SearchWorker<Strategy: SearchStrategy> {
//    
//    let networkService: NetworkService
//    let strategy: Strategy
//    
//    init(networkService: NetworkService, strategy: Strategy) {
//        self.networkService = networkService
//        self.strategy = strategy
//    }
//    
//    func search(query: String) -> AnyPublisher<[Strategy.ModelType], Never> {
//        let endpoint = strategy.endpoint()
//        let queryItems: [URLQueryItem] = strategy.queryItems(for: query)
//        
//        return Future<[Strategy.ResponseType], Never> { promise in
//            self.networkService.request(
//                endpoint: endpoint,
//                method: .get,
//                queryItems: queryItems,
//                body: nil
//            ) { (result: Result<[Strategy.ModelType]?, NetworkError>) in
//                switch result {
//                case .success(let models):
//                    promise(.success(models ?? []))
//                case .failure(let error):
//                    print("Search error: \(error)")
//                    promise(.success([]))
//                }
//            }
//        }
//        .eraseToAnyPublisher()
//    }
//}
