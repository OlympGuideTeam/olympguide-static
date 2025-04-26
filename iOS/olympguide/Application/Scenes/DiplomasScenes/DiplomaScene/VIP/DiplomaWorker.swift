//
//  DiplomaWorker.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 25.04.2025.
//

import Foundation

final class DiplomaWorker {
    @InjectSingleton
    var networkService: NetworkServiceProtocol
    
    func fetchUniversities(
        for diplomaId: Int,
        completion: @escaping (Result<[UniversityModel], Error>) -> Void
    ) {
        networkService.request(
            endpoint: "/user/diploma/\(diplomaId)/universities",
            method: .get,
            queryItems: nil,
            body: nil,
            shouldCache: true
        ) { (result: Result<[UniversityModel]?, NetworkError>) in
            switch result {
            case .success(let universities):
                completion(.success(universities ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchBenefits(
        for diplomaId: Int,
        and universityId: Int,
        with params: [Param],
        completion: @escaping (Result<[ProgramWithBenefitsModel]?, any Error>) -> Void
    ) {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "university_id", value: "\(universityId)"))
        for param in params {
            queryItems.append(param.urlValue)
        }
        
        networkService.request(
            endpoint: "/user/diploma/\(diplomaId)/benefits",
            method: .get,
            queryItems: queryItems,
            body: nil,
            shouldCache: true
        ) { (result: Result<[ProgramWithBenefitsModel]?, NetworkError>) in
            switch result {
            case .success(let programs):
                completion(.success(programs))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


