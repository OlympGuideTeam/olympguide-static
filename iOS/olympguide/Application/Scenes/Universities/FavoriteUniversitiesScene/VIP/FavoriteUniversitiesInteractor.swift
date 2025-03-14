//
//  FavoriteUniversitiesInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 12.03.2025.
//

import Foundation
import Combine

// MARK: - Universitiesnteractor
final class FavoriteUniversitiesInteractor: UniversitiesBusinessLogic, UniversitiesDataStore {
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

extension FavoriteUniversitiesInteractor {
    private func setupBindings() {
        favoritesManager.universityEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(let university):
                    guard getIndex(for: event.id) == nil else { return }
                    let insertIndex = getInsertIndex(for: university.universityID)
                    likeUniversity(university, at: insertIndex)
                    presenter?.presentSetFavorite(at: insertIndex, isFavorite: true)
                case .removed:
                    guard let index = getIndex(for: event.id) else { return }
                    dislikeUniversity(at: index)
                    presenter?.presentSetFavorite(at: index, isFavorite: false)
                case .error(let universityID):
                    handleBatchError(universityID: universityID)
                case .access(let universityID, let isFavorite):
                    handleBatchSuccess(universityID: universityID, isFavorite: isFavorite)
                }
            }
            .store(in: &cancellables)
    }
    
    private func getIndex(for universityId: Int) -> Int? {
        self.universities.firstIndex(where: {$0.universityID == universityId})
    }
    
    private func getInsertIndex(for universityId: Int) -> Int {
        self.universities.firstIndex {$0.universityID > universityId} ?? self.universities.count
    }
    
    func handleBatchError(universityID: Int) {
        if let university = removeUniversities[universityID] {
            let insetrIndex = universities.firstIndex { $0.universityID > university.universityID} ?? universities.count
            universities.insert(university, at: insetrIndex)
        } else {
            if let removeIndex = universities.firstIndex(where: { $0.universityID == universityID }) {
                universities.remove(at: removeIndex)
            }
        }

        let response = Universities.Load.Response(universities: universities)
        presenter?.presentUniversities(with: response)
    }

    func handleBatchSuccess(universityID: Int, isFavorite: Bool) {
        if !isFavorite {
            removeUniversities[universityID] = nil
        }
    }
    
    func dislikeUniversity(at index: Int) {
        let university = universities.remove(at: index)
        removeUniversities[university.universityID] = university
    }

    func likeUniversity(_ university: UniversityModel, at insertIndex: Int) {
        universities.insert(university, at: insertIndex)
        removeUniversities[university.universityID] = nil
    }
    func restoreFavorite(at index: Int) -> Bool {
        universities[index].like ?? false
    }
}

