//
//  Protocols.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import Foundation

// MARK: - Business Logic
protocol FieldBusinessLogic {
    func loadPrograms(with request: Field.LoadPrograms.Request)
}

// MARK: - Data Store
protocol FieldDataStore {
    var programs: [ProgramsByUniversityModel]? { get }
}

// MARK: - Presentation Logic
protocol FieldPresentationLogic {
    func presentLoadPrograms(with response: Field.LoadPrograms.Response)
}

// MARK: - Display Logic
protocol FieldDisplayLogic: AnyObject {
    func displayLoadProgramsResult(with viewModel: Field.LoadPrograms.ViewModel)
}

// MARK: - Routing Logic
protocol FieldRoutingLogic {
    func routeToProgram(indexPath: IndexPath)
}

// MARK: - Data Passing
protocol FieldDataPassing {
    var dataStore: FieldDataStore? { get }
}
