//
//  OlympiadWorker.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import Foundation

protocol OlympiadWorkerLogic {
    func fetchUniversities(
        for olympiadID: Int,
        completion: @escaping (Result<[UniversityModel], Error>) -> Void
    )
}

class OlympiadWorker : OlympiadWorkerLogic {
    
    private let networkService: NetworkService
    
    init() {
        self.networkService = NetworkService()
    }
    
    func fetchUniversities(
        for olympiadID: Int,
        completion: @escaping (Result<[UniversityModel], Error>) -> Void
    ) {
        
        networkService.request(
            endpoint: "/olympiad/\(olympiadID)/universities",
            method: .get,
            queryItems: nil,
            body: nil
        ) { (result: Result<[UniversityModel]?, NetworkError>) in
            switch result {
            case .success(let universities):
                completion(.success(universities ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension OlympiadWorker : BenefitsByProgramsWorkerLogic {
    func fetchBenefits(
        for olympiadId: Int,
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
            endpoint: "/olympiad/\(olympiadId)/benefits",
            method: .get,
            queryItems: queryItems,
            body: nil
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
