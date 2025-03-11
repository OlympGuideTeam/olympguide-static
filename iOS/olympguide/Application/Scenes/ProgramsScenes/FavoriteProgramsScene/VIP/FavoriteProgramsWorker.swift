//
//  Worker.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import Foundation

protocol FavoriteProgramsWorkerLogic {
    func fetchPrograms(
        completion: @escaping (Result<[ProgramsByUniversityModel], Error>) -> Void
    )
}

class FavoriteProgramsWorker : FavoriteProgramsWorkerLogic {
    
    @InjectSingleton
    var networkService: NetworkServiceProtocol
    
    func fetchPrograms(
        completion: @escaping (Result<[ProgramsByUniversityModel], Error>) -> Void
    ) {
        networkService.request(
            endpoint: "/user/favourite/programs",
            method: .get,
            queryItems: nil,
            body: nil,
            shouldCache: false
        ) { (result: Result<[ProgramsByUniversityModel]?, NetworkError>) in
            switch result {
            case .success(let programs):
                completion(.success(programs ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
