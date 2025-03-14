//
//  UniversityProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

// MARK: - Business Logic
protocol UniversityBusinessLogic {
    var isFavorite: Bool? { get set }
    func loadUniversity(with request: University.Load.Request)
    func toggleFavorite(with request: University.Favorite.Request)
}

// MARK: - Data Store
protocol UniversityDataStore {
    var universityID: Int? { get }
}

// MARK: - Presentation Logic
protocol UniversityPresentationLogic {
    func presentLoadUniversity(with response: University.Load.Response)
    func presentToggleFavorite(with response: University.Favorite.Response)
    func presentSetFavorite(to isFavorite: Bool)
}

// MARK: - Display Logic
protocol UniversityDisplayLogic: AnyObject {
    func displayLoadResult(with viewModel: University.Load.ViewModel)
    func displayToggleFavoriteResult(with viewModel: University.Favorite.ViewModel)
    func displayftSetFavorite(to isFavorite: Bool)
}

// MARK: - Routing Logic
protocol UniversityRoutingLogic {
    func routeToProgramsByFields(for university: UniversityModel)
    func routeToProgramsByFaculties(for university: UniversityModel)
}

// MARK: - Data Passing
protocol UniversityDataPassing {
    var universityDataStore: UniversityDataStore? { get }
}
