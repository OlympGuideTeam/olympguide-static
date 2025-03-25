//
//  Protocols.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

// MARK: - Business Logic
protocol DiplomasBusinessLogic {
    func loadDiplomas(with request: Diplomas.Load.Request)
    func deleteDiploma(with request: Diplomas.Delete.Request)
}

// MARK: - Data Store
protocol DiplomasDataStore {
    
}

// MARK: - Presentation Logic
protocol DiplomasPresentationLogic {
    func presentLoadDiplomas(with response: Diplomas.Load.Response)
    func presentDeleteDiploma(with response: Diplomas.Delete.Response)
}

// MARK: - Display Logic
protocol DiplomasDisplayLogic: AnyObject {
    func displayLoadDiplomasResult(with viewModel: Diplomas.Load.ViewModel)
    func displayDeleteDiplomaResult(with viewModel: Diplomas.Delete.ViewModel)
}

// MARK: - Routing Logic
protocol DiplomasRoutingLogic {
    func routeTo()
}

// MARK: - Data Passing
protocol DiplomasDataPassing {
    var dataStore: DiplomasDataStore? { get }
}
