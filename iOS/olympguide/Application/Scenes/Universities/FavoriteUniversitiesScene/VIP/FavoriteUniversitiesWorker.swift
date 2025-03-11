//
//  FavoriteUniversitiesWorker.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import Foundation

final class FavoriteUniversitiesWorker : UniversitiesWorkerLogic {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
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
            endpoint: "/user/favourite/universities",
            method: .get,
            queryItems: queryItems,
            body: nil,
            shouldCache: false
        ) { (result: Result<[UniversityModel]?, NetworkError>) in
            switch result {
            case .success(let universities):
                if let universities = universities {
                    _ = universities.map { university in
                        var modifiedUniversity = university
                        modifiedUniversity.like = isFavorite(
                            univesityID: university.universityID,
                            serverValue: university.like ?? false
                        )
                        return modifiedUniversity
                    }.filter { $0.like ?? false }
                }
                completion(.success(universities))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        
        func isFavorite(univesityID: Int, serverValue: Bool) -> Bool {
            favoritesManager.isUniversityFavorited(
                universityID: univesityID,
                serverValue: serverValue
            )
        }
    }
}
