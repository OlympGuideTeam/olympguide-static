//
//  UniversityInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import Foundation
import Combine

// MARK: - UniversityInteractor
final class UniversityInteractor: UniversityDataStore, ProgramsDataStore {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    var groupsOfPrograms: [GroupOfProgramsModel] = []
    
    var university: UniversityModel?
    var universityID: Int?
    var isFavorite: Bool?
    
    var presenter: (UniversityPresentationLogic & ProgramsPresentationLogic)?
    var worker = UniversityWorker()
    
    init() {
        setupUniversityBindings()
        setupProgramsBindings()
    }
}

// MARK: - UniversityBusinessLogic
extension UniversityInteractor : UniversityBusinessLogic {
    func loadUniversity(with request: University.Load.Request) {
        universityID = request.universityID
        worker.fetchUniverity(
            with: request.universityID
        ) { [weak self] result in
            switch result {
            case .success(let university):
                let response = University.Load.Response(
                    error: nil,
                    site: university.site,
                    email: university.email
                )
                self?.presenter?.presentLoadUniversity(with: response)
            case .failure(let error):
                let response = University.Load.Response(
                    error: error,
                    site: nil,
                    email: nil
                )
                self?.presenter?.presentLoadUniversity(with: response)
            }
        }
    }
    
    func toggleFavorite(with request: University.Favorite.Request) {
        worker.toggleFavorite(
            with: request.universityID,
            isFavorite: request.isFavorite
        ) { [weak self] result in
            switch result {
            case .success:
                let response = University.Favorite.Response(error: nil)
                self?.presenter?.presentToggleFavorite(with: response)
            case .failure(let error):
                let response = University.Favorite.Response(error: error)
                self?.presenter?.presentToggleFavorite(with: response)
            }
        }
    }
}
    
// MARK: - ProgramsBusinessLogic
extension UniversityInteractor : ProgramsBusinessLogic {
    func loadPrograms(with request: Programs.Load.Request) {
        guard let university = request.university else {return}
        let params: [Param] = request.params.flatMap { key, value in
            value.array
        }
        worker.loadPrograms(
            with: params,
            for: university.universityID,
            by: request.groups
        ) { [weak self] result in
            switch result {
            case .success(let programs):
                self?.groupsOfPrograms = programs
                let response = Programs.Load.Response(groupsOfPrograms: programs, error: nil)
                self?.presenter?.presentLoadPrograms(with: response)
            case .failure(let error):
                let response = Programs.Load.Response(groupsOfPrograms: nil, error: error)
                self?.presenter?.presentLoadPrograms(with: response)
            }
        }
    }
    
    func program(at indexPath: IndexPath) -> ProgramShortModel {
        groupsOfPrograms[indexPath.section].programs[indexPath.row]
    }
}

extension UniversityInteractor {
    private func setupUniversityBindings() {
        favoritesManager.universityEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                guard universityID == event.id else { return }
                switch event {
                case .added:
                    presenter?.presentSetFavorite(to: true)
                case .removed:
                    presenter?.presentSetFavorite(to: false)
                case .error:
                    guard let isFavorite = isFavorite else { return }
                    presenter?.presentSetFavorite(to: isFavorite)
                case .access(_, let isFavorite):
                    self.isFavorite = isFavorite
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupProgramsBindings() {
        favoritesManager.programEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                guard
                    let indexPath = getIndexPath(for: event.programId)
                else { return }
                switch event {
                case .added:
                    presenter?.presentSetFavorite(at: indexPath, isFavorite: true)
                case .removed:
                    presenter?.presentSetFavorite(at: indexPath, isFavorite: false)
                case .error:
                    let isFavorite = groupsOfPrograms[indexPath.section].programs[indexPath.row].like
                    presenter?.presentSetFavorite(at: indexPath, isFavorite: isFavorite)
                case .access(_, let isFavorite):
                    groupsOfPrograms[indexPath.section].programs[indexPath.row].like  = isFavorite
                }
            }
            .store(in: &cancellables)
    }
    
    private func getIndexPath(for programId: Int) -> IndexPath? {
        guard
            let groupIndex = groupsOfPrograms.firstIndex(where: { group in
                group.programs.contains { $0.programID == programId }
            })
        else { return nil }
        
        return groupsOfPrograms[groupIndex].programs.firstIndex(where: { $0.programID == programId })
            .map { IndexPath(row: $0, section: groupIndex) }
    }
}
