//
//  OlympiadsInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

import Foundation
import Combine

// MARK: - Olympiadsnteractor
final class OlympiadsInteractor: OlympiadsBusinessLogic, OlympiadsDataStore {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var presenter: OlympiadsPresentationLogic?
    var worker: OlympiadsWorkerLogic?
    var olympiads: [OlympiadModel] = []
    var params: Dictionary<ParamType, SingleOrMultipleArray<Param>> = [:]
    
    init() {
        setupBindings()
    }
    
    func loadOlympiads(with request: Olympiads.Load.Request) {
        let params: [Param] = request.params.flatMap { key, value in
            value.array
        }
        self.params = request.params
        worker?.fetchOlympiads(
            with: params
        ) { [weak self] result in
            switch result {
            case .success(let olympiads):
                self?.olympiads = olympiads
                let response = Olympiads.Load.Response(olympiads: olympiads)
                self?.presenter?.presentLoadOlympiads(with: response)
            case .failure(let error):
                let response = Olympiads.Load.Response(error: error)
                self?.presenter?.presentLoadOlympiads(with: response)
            }
        }
    }
    
    func olympiadModel(at index: Int) -> OlympiadModel {
        olympiads[index]
    }
    
    private func setupBindings() {
        favoritesManager.olympiadEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                guard let index = findIndex(of: event.id) else { return }
                switch event {
                case .added:
                    presenter?.presentSetFavorite(at: index, true)
                case .removed:
                    presenter?.presentSetFavorite(at: index, false)
                case .error:
                    let isFavorite = olympiads[index].like
                    presenter?.presentSetFavorite(at: index, isFavorite)
                case .access(_, let isFavorite):
                    olympiads[index].like = isFavorite
                }
                
            }.store(in: &cancellables)
    }
    
    private func findIndex(of olympiadId: Int) -> Int? {
        self.olympiads.firstIndex(where: { $0.olympiadID == olympiadId} )
    }
}
