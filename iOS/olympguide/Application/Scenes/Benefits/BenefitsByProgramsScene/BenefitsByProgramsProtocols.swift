//
//  BenefitsByProgramsProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 05.03.2025.
//

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
        and universityId: Int,
        with params: [Param],
        completion: @escaping (Result<[ProgramWithBenefitsModel]?, Error>) -> Void
    )
}


