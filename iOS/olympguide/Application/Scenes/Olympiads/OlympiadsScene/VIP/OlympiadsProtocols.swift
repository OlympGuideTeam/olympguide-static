//
//  OlimpiadsProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

import Foundation

protocol OlympiadsBusinessLogic {
    func loadOlympiads(_ request: Olympiads.Load.Request)
    func favoriteStatus(at index: Int) -> Bool
    func olympiadModel(at index: Int) -> OlympiadModel
    func setFavoriteStatus(at index: Int, to isFavorite: Bool)
}

protocol OlympiadsPresentationLogic {
    func presentOlympiads(_ response: Olympiads.Load.Response)
    func presentError(message: String)
}

protocol OlympiadsDisplayLogic: AnyObject {
    func displayOlympiads(_ viewModel: Olympiads.Load.ViewModel)
    func displayError(message: String)
}

protocol OlympiadsRoutingLogic {
    func routeToSearch()
    func routeToOlympiad(with index: Int)
}

protocol OlympiadsDataStore {
    var olympiads: [OlympiadModel] { get set }
}

protocol OlympiadsDataPassing {
    var dataStore: OlympiadsDataStore? { get }
}

