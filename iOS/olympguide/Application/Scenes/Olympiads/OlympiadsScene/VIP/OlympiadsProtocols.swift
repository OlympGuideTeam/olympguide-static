//
//  OlimpiadsProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

import Foundation

protocol OlympiadsBusinessLogic {
    func loadOlympiads(with request: Olympiads.Load.Request)
    func olympiadModel(at index: Int) -> OlympiadModel
}

protocol OlympiadsPresentationLogic {
    func presentLoadOlympiads(with response: Olympiads.Load.Response)
    func presentSetFavorite(at index: Int, _ isFavorite: Bool)
}

protocol OlympiadsDisplayLogic: AnyObject {
    func displayOlympiads(with viewModel: Olympiads.Load.ViewModel)
    func displaySetFavorite(at index: Int, _ isFavorite: Bool)
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

