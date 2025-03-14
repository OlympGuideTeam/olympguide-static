//
//  UniversitiesInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import Foundation
import Combine

// MARK: - Universitiesnteractor
final class UniversitiesInteractor : UniversitiesDataStore {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    var presenter: UniversitiesPresentationLogic?
    var worker: UniversitiesWorkerLogic?
    var universities: [UniversityModel] = []
    var params: Dictionary<ParamType, SingleOrMultipleArray<Param>> = [:]
    var removeUniversities: [Int: UniversityModel] = [:]
    
    init() {
        setupBindings()
    }
}

// MARK: - UniversitiesBusinessLogic
extension UniversitiesInteractor : UniversitiesBusinessLogic {
    func loadUniversities(with request: Universities.Load.Request) {
        params = request.params
        let params: [Param] = request.params.flatMap { key, value in
            value.array
        }
        worker?.fetchUniversities(
            with: params
        ) { [weak self] result in
            switch result {
            case .success(let universities):
                self?.universities = universities ?? []
                let response = Universities.Load.Response(universities: universities ?? [])
                self?.presenter?.presentUniversities(with: response)
            case .failure(let error):
                let response = Universities.Load.Response(error: error)
                self?.presenter?.presentUniversities(with: response)
            }
        }
    }
    
    func universityModel(at index: Int) -> UniversityModel {
        universities[index]
    }
    
}

extension UniversitiesInteractor {
    private func setupBindings() {
        favoritesManager.universityEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                guard let index = getIndex(for: event.id) else { return }
                switch event {
                case .added:
                    presenter?.presentSetFavorite(at: index, isFavorite: true)
                case .removed:
                    presenter?.presentSetFavorite(at: index, isFavorite: false)
                case .error:
                    let isFavorite: Bool = universities[index].like ?? false
                    presenter?.presentSetFavorite(at: index, isFavorite: isFavorite)
                case .access(_, let isFavorite):
                    universities[index].like = isFavorite
                }
            }
            .store(in: &cancellables)
    }
    
    private func getIndex(for universityId: Int) -> Int? {
        self.universities.firstIndex(where: {$0.universityID == universityId})
    }
}
