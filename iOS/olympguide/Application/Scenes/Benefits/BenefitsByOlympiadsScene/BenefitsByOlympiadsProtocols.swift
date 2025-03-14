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

protocol BenefitsByOlympiadsWorkerLogic {
    func fetchBenefits(
        for progrmaId: Int,
        with params: [Param],
        completion: @escaping (Result<[OlympiadWithBenefitsModel]?, Error>) -> Void
    )
}
