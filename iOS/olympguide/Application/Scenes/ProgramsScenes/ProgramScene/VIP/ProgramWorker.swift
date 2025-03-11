//
//  Worker.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//
import Foundation

protocol ProgramWorkerLogic {
    func fetchProgram(
        with programId: Int,
        completion: @escaping (Result<ProgramModel, Error>) -> Void
    )
}

final class ProgramWorker : ProgramWorkerLogic {
    @InjectSingleton
        var networkService: NetworkServiceProtocol
    
    func fetchProgram(
        with programId: Int,
        completion: @escaping (Result<ProgramModel, Error>) -> Void
    ) {
        networkService.request(
            endpoint: "/program/\(programId)",
            method: .get,
            queryItems: nil,
            body: nil,
            shouldCache: true
        ) { (result: Result<ProgramModel, NetworkError>) in
            switch result {
            case .success(let program):
                completion(.success(program))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension ProgramWorker : BenefitsByOlympiadsWorkerLogic {
    func fetchBenefits(
        for progrmaId: Int,
        with params: [Param],
        completion: @escaping (Result<[OlympiadWithBenefitsModel]?, Error>) -> Void
    ) {
        var queryItems: [URLQueryItem] = []
        
        for param in params {
            queryItems.append(param.urlValue)
        }
        
        networkService.request(
            endpoint: "/program/\(progrmaId)/benefits",
            method: .get,
            queryItems: queryItems,
            body: nil,
            shouldCache: true
        ) { (result: Result<[OlympiadWithBenefitsModel]?, NetworkError>) in
            switch result {
            case .success(let olympiads):
                completion(.success(olympiads))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
