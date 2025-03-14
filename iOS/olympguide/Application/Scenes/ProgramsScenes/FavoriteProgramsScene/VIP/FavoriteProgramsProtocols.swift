//
//  Protocols.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import Foundation

// MARK: - Business Logic
protocol FavoriteProgramsBusinessLogic {
    func loadPrograms(with request: FavoritePrograms.Load.Request)
}

// MARK: - Data Store
protocol FavoriteProgramsDataStore {
    var programs: [ProgramsByUniversityModel] { get }
}

// MARK: - Presentation Logic
protocol FavoriteProgramsPresentationLogic {
    func presentLoadPrograms(with response: FavoritePrograms.Load.Response)
    func presentSetFavorite(at indexPath: IndexPath)
}

// MARK: - Display Logic
protocol FavoriteProgramsDisplayLogic: AnyObject {
    func displayLoadProgramsResult(with viewModel: FavoritePrograms.Load.ViewModel)
    func displaySetFavoriteResult(at indexPath: IndexPath)
}

// MARK: - Routing Logic
protocol FavoriteProgramsRoutingLogic {
    func routeToProgram(indexPath: IndexPath)
}

// MARK: - Data Passing
protocol FavoriteProgramsDataPassing {
    var dataStore: FavoriteProgramsDataStore? { get }
}
