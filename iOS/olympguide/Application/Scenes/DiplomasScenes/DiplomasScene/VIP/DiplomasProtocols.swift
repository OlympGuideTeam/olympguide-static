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
    func syncDiplomas(with request: Diplomas.Sync.Request)
}

// MARK: - Data Store
protocol DiplomasDataStore {
    var diplomas: [DiplomaModel] { get set }
}

// MARK: - Presentation Logic
protocol DiplomasPresentationLogic {
    func presentLoadDiplomas(with response: Diplomas.Load.Response)
    func presentDeleteDiploma(with response: Diplomas.Delete.Response)
    func presentSyncDiplomas(with response: Diplomas.Sync.Response)
}

// MARK: - Display Logic
protocol DiplomasDisplayLogic: AnyObject {
    func displayLoadDiplomasResult(with viewModel: Diplomas.Load.ViewModel)
    func displayDeleteDiplomaResult(with viewModel: Diplomas.Delete.ViewModel)
}

// MARK: - Routing Logic
protocol DiplomasRoutingLogic {
    func routeToAddDiploma()
    func routeToDiploma(at index: Int)
}

// MARK: - Data Passing
protocol DiplomasDataPassing {
    var dataStore: DiplomasDataStore? { get }
}
