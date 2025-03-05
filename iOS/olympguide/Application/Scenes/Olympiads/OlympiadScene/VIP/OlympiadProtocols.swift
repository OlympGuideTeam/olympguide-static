//
//  OlympiadProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

// MARK: - Business Logic
protocol OlympiadBusinessLogic {
    func loadUniversities(with request: Olympiad.LoadUniversities.Request)
}

// MARK: - Data Store
protocol DataStore {
    
}

// MARK: - Presentation Logic
protocol OlympiadPresentationLogic {
    func presentLoadUniversities(with response: Olympiad.LoadUniversities.Response)
}

// MARK: - Display Logic
protocol OlympiadDisplayLogic: AnyObject {
    func displayLoadUniversitiesResult(with viewModel: Olympiad.LoadUniversities.ViewModel)
}

// MARK: - Routing Logic
protocol OlympiadRoutingLogic {
    func routeToProgram()
}

// MARK: - Data Passing
protocol OlympiadDataPassing {
    var dataStore: DataStore? { get }
}
