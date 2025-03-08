//
//  OlympiadsInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

// MARK: - Olympiadsnteractor
final class OlympiadsInteractor: OlympiadsBusinessLogic, OlympiadsDataStore {
    var presenter: OlympiadsPresentationLogic?
    var worker: OlympiadsWorkerLogic?
    var olympiads: [OlympiadModel] = []
    var params: Dictionary<ParamType, SingleOrMultipleArray<Param>> = [:]
    
    func loadOlympiads(_ request: Olympiads.Load.Request) {
        let params: [Param] = request.params.flatMap { key, value in
            value.array
        }
        self.params = request.params
        worker?.fetchOlympiads(
            with: params
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
