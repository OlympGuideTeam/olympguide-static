//
//  UniversitiesProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

protocol UniversitiesBusinessLogic {
    func loadUniversities(with request: Universities.Load.Request)
    func universityModel(at index: Int) -> UniversityModel
}

protocol UniversitiesPresentationLogic {
    func presentUniversities(with response: Universities.Load.Response)
    func presentSetFavorite(at index: Int, isFavorite: Bool)
}

protocol UniversitiesDisplayLogic: AnyObject {
    func displayUniversities(with viewModel: Universities.Load.ViewModel)
    func displaySetFavorite(at index: Int, isFavorite: Bool)
}

protocol UniversitiesRoutingLogic {
    func routeToUniversity(for index: Int)
    func routeToSearch()
}

protocol UniversitiesDataStore {
    var universities: [UniversityModel] { get set }
}

protocol UniversitiesDataPassing {
    var dataStore: UniversitiesDataStore? { get }
}
