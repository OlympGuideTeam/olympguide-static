//
//  FavoriteOlympiadsInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 07.03.2025.
//

import Foundation
import Combine

// MARK: - Olympiadsnteractor
final class FavoriteOlympiadsInteractor : OlympiadsBusinessLogic, OlympiadsDataStore {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    var presenter: OlympiadsPresentationLogic?
    var worker: OlympiadsWorkerLogic?
    var olympiads: [OlympiadModel] = []
    var removedOlympiads: [Int: OlympiadModel] = [:]
    var params: Dictionary<ParamType, SingleOrMultipleArray<Param>> = [:]
    
    init() {
        setupBindings()
    }
    
    func loadOlympiads(with request: Olympiads.Load.Request) {
        params = request.params
        worker?.fetchOlympiads(
            with: []
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
}

// MARK: - Combine
extension FavoriteOlympiadsInteractor {
    private func setupBindings() {
        favoritesManager.olympiadEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(let olympiad):
                    likeOlympiad(olympiad)
                case .removed(let olympiadId):
                    guard let index = getIndex(for: olympiadId) else { return }
                    dislikeOlympiad(at: index)
                    presenter?.presentSetFavorite(at: index, false)
                case .error(let olympiadId):
                    handleBatchError(olympiadID: olympiadId)
                case .access(let olympiadId, let isFavorite):
                    handleBatchSuccess(olympiadID: olympiadId, isFavorite: isFavorite)
                }
            }
            .store(in: &cancellables)
    }
    
    private func getIndex(for olympiadId: Int) -> Int? {
        self.olympiads.firstIndex(where: { $0.olympiadID == olympiadId })
    }
    
    private func getInsertIndex(for olympiadId: Int) -> Int {
        self.olympiads.firstIndex {$0.olympiadID > olympiadId} ?? self.olympiads.count
    }
    
    func handleBatchSuccess(olympiadID: Int, isFavorite: Bool) {
        if !isFavorite {
            removedOlympiads[olympiadID] = nil
        }
    }
    
    func dislikeOlympiad(at index: Int) {
        let olympiad = olympiads.remove(at: index)
        removedOlympiads[olympiad.olympiadID] = olympiad
    }
    
    func likeOlympiad(_ olympiad: OlympiadModel) {
        guard getIndex(for: olympiad.olympiadID) == nil else { return }
        let insertIndex = getInsertIndex(for: olympiad.olympiadID)
        var modifiedOlympiad = olympiad
        modifiedOlympiad.like = true
        olympiads.insert(modifiedOlympiad, at: insertIndex)
        removedOlympiads[modifiedOlympiad.olympiadID] = nil
        
        let response = Olympiads.Load.Response(olympiads: olympiads)
        presenter?.presentLoadOlympiads(with: response)
    }
    
    func handleBatchError(olympiadID: Int) {
        if let olympiad = removedOlympiads[olympiadID] {
            let insertIndex = olympiads.firstIndex { $0.olympiadID > olympiad.olympiadID } ?? olympiads.count
            olympiads.insert(olympiad, at: insertIndex)
        } else{
            if let removeIndex = olympiads.firstIndex(where: { $0.olympiadID == olympiadID }) {
                olympiads.remove(at: removeIndex)
            }
        }
    }
}
    
