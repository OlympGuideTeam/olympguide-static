//
//  BenefitsProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import Foundation

// MARK: - By olympiads
// MARK: - Business Logic
protocol BenefitsByOlympiadsBusinessLogic {
    func loadBenefits(with request: BenefitsByOlympiads.Load.Request)
}

// MARK: - Data Store
// Храним данные, которые могут потребоваться при переходе на другой экран
protocol BenefitsByOlympiadsDataStore {
    
}

// MARK: - Presentation Logic
protocol BenefitsByOlympiadsPresentationLogic {
    func presentLoadBenefits(with response: BenefitsByOlympiads.Load.Response)
}

// MARK: - Display Logic
protocol BenefitsByOlympiadsDisplayLogic: AnyObject {
    func displayLoadBenefitsResult(with viewModel: BenefitsByOlympiads.Load.ViewModel)
}

// MARK: - Routing Logic
protocol BenefitsByOlympiadsRoutingLogic {
    func routeTo()
}

// MARK: - Data Passing
protocol BenefitsByOlympiadsDataPassing {
    var dataStore: BenefitsByOlympiadsDataStore? { get }
}

protocol BenefitsByOlympiadsWorkerLogic {
    func fetchBenefits(
        for progrmaId: Int,
        with params: [Param],
        completion: @escaping (Result<[OlympiadWithBenefitsModel]?, Error>) -> Void
    )
}

// MARK: - By programs
protocol BenefitsByProgramsBusinessLogic {
    func loadBenefits(with request: BenefitsByPrograms.Load.Request)
}

protocol BenefitsByProgramsDataStore {
    
}

protocol BenefitsByProgramsPresentationLogic {
    func presentLoadBenefits(with response: BenefitsByPrograms.Load.Response)
}

protocol BenefitsByProgramsDisplayLogic: AnyObject {
    func displayLoadBenefitsResult(with viewModel: BenefitsByPrograms.Load.ViewModel)
}

protocol BenefitsByProgramsRoutingLogic {
    func routeTo()
}

protocol BenefitsByProgramsDataPassing {
    var dataStore: BenefitsByProgramsDataStore? { get }
}

protocol BenefitsByProgramsWorkerLogic {
    func fetchBenefits(
        for olympiadId: Int,
        with params: [Param],
        completion: @escaping (Result<[ProgramWithBenefitsModel]?, Error>) -> Void
    )
}

