//
//  FieldInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import Foundation
import Combine

final class FieldInteractor : FieldDataStore {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    var presenter: FieldPresentationLogic?
    var worker: FieldWorkerLogic?
    var programs: [ProgramsByUniversityModel]?
    
    init() {
        setupProgramsBindings()
    }
}

// MARK: - FieldBusinessLogic
extension FieldInteractor: FieldBusinessLogic {
    func loadPrograms(with request: Field.LoadPrograms.Request) {
        let params: [Param] = request.params.flatMap { key, value in
            value.array
        }
        worker?.fetchPrograms(
            for: request.fieldID,
            with: params
        ) { [weak self] result in
            switch result {
            case .success(let programs):
                self?.programs = programs
                let response = Field.LoadPrograms.Response(programs: programs ?? [])
                self?.presenter?.presentLoadPrograms(with: response)
            case .failure(let error):
                let response = Field.LoadPrograms.Response(error: error)
                self?.presenter?.presentLoadPrograms(with: response)
            }
        }
    }
    
    func getProgram(at indexPath: IndexPath) -> ProgramShortModel? {
        programs?[indexPath.section].programs[indexPath.row]
    }
    
    func getUniversity(at index: Int) -> UniversityModel? {
        programs?[index].univer
    }
}

// MARK: - Combine
extension FieldInteractor {
    private func setupProgramsBindings() {
        favoritesManager.programEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                guard let indexPath = getIndexPath(to: event.programId) else { return }
                switch event {
                case .added:
                    presenter?.presentSetFavorite(at: indexPath, true)
                case .removed:
                    presenter?.presentSetFavorite(at: indexPath, false)
                case .error:
                    guard
                        let isFavorite = programs?[indexPath.section].programs[indexPath.row].like
                    else { return }
                    presenter?.presentSetFavorite(at: indexPath, isFavorite)
                case .access(_, let isFavorite):
                    programs?[indexPath.section].programs[indexPath.row].like = isFavorite
                }
            }.store(in: &cancellables)
    }
    
    func getIndexPath(to programId: Int) -> IndexPath? {
        guard
            let uniIndex = programs?.firstIndex(where: { group in
                group.programs.contains(where: { $0.programID == programId })
            }),
            let programIndex = programs?[uniIndex].programs.firstIndex(where: { $0.programID == programId })
        else { return nil}
        
        return IndexPath(row: programIndex, section: uniIndex)
    }
    
}

