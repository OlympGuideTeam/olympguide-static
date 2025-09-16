//
//  AddDiplomaProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 26.04.2025.
//

// MARK: - Business Logic
protocol AddDiplomaBusinessLogic {
    func addDiploma(with request: AddDiploma.Request)
}

// MARK: - Data Store
// Храним данные, которые могут потребоваться при переходе на другой экран
protocol DataStore {
    
}

// MARK: - Presentation Logic
protocol AddDiplomaPresentationLogic {
    func presentAddDiploma(with response: AddDiploma.Response)
}

// MARK: - Display Logic
protocol AddDiplomaDisplayLogic: AnyObject {
    func displayAddDiplomaResult(with viewModel: AddDiploma.ViewModel)
    var classTextField: OptionsTextField { get }
    var diplomaLevelTextField: OptionsTextField { get }
}

// MARK: - Routing Logic
protocol AddDiplomaRoutingLogic {
    func routeToRoot()
}

// MARK: - Data Passing
protocol AddDiplomaDataPassing {
    var dataStore: DataStore? { get }
}
