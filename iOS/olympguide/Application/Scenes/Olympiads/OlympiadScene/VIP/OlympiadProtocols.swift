//
//  OlympiadProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import Foundation

// MARK: - Business Logic
protocol OlympiadBusinessLogic {
    func loadUniversities(with request: Olympiad.LoadUniversities.Request)
    func setFavoriteStatus(_ status: Bool, to universityId: Int)
    func favoriteStatusAt(index: Int) -> Bool
    func universityModel(at index: Int) -> UniversityModel?
    var isFavorite: Bool? { get set }
}

// MARK: - Data Store
protocol OlympiadDataStore {
    var programs: [[ProgramWithBenefitsModel]]? { get }
    var universities: [UniversityModel]? { get }
    var allUniversities: [UniversityModel]? { get }
}

// MARK: - Presentation Logic
protocol OlympiadPresentationLogic {
    func presentLoadUniversities(with response: Olympiad.LoadUniversities.Response)
    func presentSetFavorite(to isFavorite: Bool)
}

// MARK: - Display Logic
protocol OlympiadDisplayLogic: AnyObject {
    func displayLoadUniversitiesResult(with viewModel: Olympiad.LoadUniversities.ViewModel)
    func displaySetFavorite(to isFavorite: Bool)
}

// MARK: - Routing Logic
protocol OlympiadRoutingLogic {
    func routeToProgram(indexPath: IndexPath)
    func routeToSearch(olympiadId: Int)
}

// MARK: - Data Passing
protocol OlympiadDataPassing {
    var dataStore: OlympiadDataStore? { get }
}
