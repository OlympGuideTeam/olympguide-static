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
    func likeProgram(_ univer: UniversityModel, _ program: ProgramShortModel)
    func handleBatchError(programID: Int)
    func handleBatchSuccess(programID: Int, isFavorite: Bool)
    func dislikeProgram(at indexPath: IndexPath)
}

// MARK: - Data Store
protocol FavoriteProgramsDataStore {
    var programs: [ProgramsByUniversityModel] { get }
}

// MARK: - Presentation Logic
protocol FavoriteProgramsPresentationLogic {
    func presentLoadPrograms(with response: FavoritePrograms.Load.Response)
}

// MARK: - Display Logic
protocol FavoriteProgramsDisplayLogic: AnyObject {
    func displayLoadProgramsResult(with viewModel: FavoritePrograms.Load.ViewModel)
}

// MARK: - Routing Logic
protocol FavoriteProgramsRoutingLogic {
    func routeToProgram(indexPath: IndexPath)
}

// MARK: - Data Passing
protocol FavoriteProgramsDataPassing {
    var dataStore: FavoriteProgramsDataStore? { get }
}
