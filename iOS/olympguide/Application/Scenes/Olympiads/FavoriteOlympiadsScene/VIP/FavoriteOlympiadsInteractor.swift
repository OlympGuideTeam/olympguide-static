//
//  FavoriteOlympiadsInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 07.03.2025.
//

// MARK: - Olympiadsnteractor
final class FavoriteOlympiadsInteractor : OlympiadsBusinessLogic, OlympiadsDataStore {
    var presenter: OlympiadsPresentationLogic?
    var worker: OlympiadsWorkerLogic?
    var olympiads: [OlympiadModel] = []
    var removedOlympiads: [Int: OlympiadModel] = [:]
    var params: Dictionary<String, Set<String>> = [:]
    
    func loadOlympiads(_ request: Olympiads.Load.Request) {
        params = request.params
        worker?.fetchOlympiads(
            with: []
        ) { [weak self] result in
            switch result {
            case .success(let olympiads):
                self?.olympiads = olympiads ?? []
                let response = Olympiads.Load.Response(olympiads: olympiads ?? [])
                self?.presenter?.presentOlympiads(response)
            case .failure(let error):
                self?.presenter?.presentError(message: error.localizedDescription)
            }
        }
    }
    
    func favoriteStatus(at index: Int) -> Bool {
        return olympiads[index].like
    }
    
    func setFavoriteStatus(at index: Int, to isFavorite: Bool) {
        olympiads[index].like = isFavorite
    }
    
    func olympiadModel(at index: Int) -> OlympiadModel {
        olympiads[index]
    }
}

extension FavoriteOlympiadsInteractor : FavoriteOlympiadsBusinessLogic {
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
    
    func handleBatchSuccess(olympiadID: Int, isFavorite: Bool) {
        if !isFavorite {
            removedOlympiads[olympiadID] = nil
        }
    }
    
    func dislikeOlympiad(at index: Int) {
        let olympiad = olympiads.remove(at: index)
        removedOlympiads[olympiad.olympiadID] = olympiad
    }
    
    func likeOlympiad(_ olympiad: OlympiadModel, at insertIndex: Int) {
        olympiads.insert(olympiad, at: insertIndex)
        removedOlympiads[olympiad.olympiadID] = nil
    }
}
    
