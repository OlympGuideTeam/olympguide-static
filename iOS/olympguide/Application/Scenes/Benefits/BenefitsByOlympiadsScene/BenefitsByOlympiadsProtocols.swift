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
    func loadOlympiads(with request: BenefitsByOlympiads.Load.Request)
}

// MARK: - Data Store
// Храним данные, которые могут потребоваться при переходе на другой экран
protocol BenefitsByOlympiadsDataStore {
    
}

// MARK: - Presentation Logic
protocol BenefitsByOlympiadsPresentationLogic {
    func presentLoadOlympiads(with response: BenefitsByOlympiads.Load.Response)
}

// MARK: - Display Logic
protocol BenefitsByOlympiadsDisplayLogic: AnyObject {
    func displayLoadOlympiadsResult(with viewModel: BenefitsByOlympiads.Load.ViewModel)
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
