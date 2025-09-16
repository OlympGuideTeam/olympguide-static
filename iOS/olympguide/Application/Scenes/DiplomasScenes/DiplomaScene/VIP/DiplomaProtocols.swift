//
//  DiplomaProtocols.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 25.04.2025.
//

import Foundation

protocol DiplomaBusinessLogic {
    func loadUniversities(with request: Diploma.LoadUniversities.Request)
}

protocol DiplomaPresentationLogic {
    func presentLoadUniversities(with response: Diploma.LoadUniversities.Response)
}

protocol DiplomaRoutingLogic {
    func routeToSearch()
    func routeToProgram(indexPath: IndexPath)
}

protocol DiplomaDisplayLogic: AnyObject {
    func displayLoadUniversitiesResult(with viewModel: Diploma.LoadUniversities.ViewModel)
}

protocol DiplomaDataStore {
    var diploma: DiplomaModel? { get set }
    var programs: [[ProgramWithBenefitsModel]]? { get }
    var universities: [UniversityModel]? { get }
    var allUniversities: [UniversityModel]? { get }
}

protocol DiplomaDataPassing {
    var dataStore: DiplomaDataStore? { get }
}

