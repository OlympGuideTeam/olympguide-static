//
//  Protocols.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import Foundation

// MARK: - Business Logic
protocol ProgramBusinessLogic {
    var programId: Int? { get set }
    var isFavorite: Bool? { get set }
    func loadProgram(with request: Program.Load.Request)
}

// MARK: - Presentation Logic
protocol ProgramPresentationLogic {
    func presentLoadProgram(with response: Program.Load.Response)
    func presentToggleFavorite(response: Program.Favorite.Response)
    func presentSetFavorite(to isFavorite: Bool)
}

// MARK: - Display Logic
protocol ProgramDisplayLogic: AnyObject {
    func displayLoadProgram(with viewModel: Program.Load.ViewModel)
    func displayToggleFavoriteResult(viewModel: Program.Favorite.ViewModel)
    func displaySetFavorite(to isFavorite: Bool)
}

// MARK: - Routing Logic
protocol ProgramRoutingLogic {
    func routeToSearch(programId: Int)
    func routToBenefit(_ benefit: OlympiadWithBenefitViewModel)
}
