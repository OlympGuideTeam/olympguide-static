//
//  Interactor.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import Foundation
import Combine

final class FavoriteProgramsInteractor: FavoriteProgramsDataStore {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    private var cancellables = Set<AnyCancellable>()

    
    var programs: [ProgramsByUniversityModel] = []
    var removedPrograms: [Int: (UniversityModel, ProgramShortModel)] = [:]
    
    var presenter: FavoriteProgramsPresentationLogic?
    var worker: FavoriteProgramsWorkerLogic?
    
    init() {
        setupBindings()
    }
}

extension FavoriteProgramsInteractor : FavoriteProgramsBusinessLogic {
    func loadPrograms(with request: FavoritePrograms.Load.Request) {
        worker?.fetchPrograms() { [weak self] result in
            switch result {
            case .success(let programs):
                self?.programs =  programs.map { program in
                    var modifiedPrograms = program
                    modifiedPrograms.programs = modifiedPrograms.programs.filter {$0.like}
                    return modifiedPrograms
                }
                self?.presenter?.presentLoadPrograms(with: FavoritePrograms.Load.Response(programs: programs))
            case .failure(let error):
                self?.presenter?.presentLoadPrograms(with: FavoritePrograms.Load.Response(error: error))
            }
        }
    }
}

extension FavoriteProgramsInteractor {
    func setupBindings() {
        favoritesManager.programEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(let univer, let program):
                    likeProgram(univer, program)
                case .removed(let programID):
                    guard let indexPath = self.findIndexPath(programID: programID) else { return }
                    dislikeProgram(at: indexPath)
                    presenter?.presentSetFavorite(at: indexPath)
                case .error(let programID):
                    handleBatchError(programID: programID)
                case .access(let programID, let isFavorite):
                    handleBatchSuccess(programID: programID, isFavorite: isFavorite)
                }
            }.store(in: &cancellables)
    }
    
    func likeProgram(_ univer: UniversityModel, _ program: ProgramShortModel) {
        var updateProgram = program
        updateProgram.like = true
        guard findIndexPath(programID: updateProgram.programID) == nil else { return }
        if let insertSection = programs.firstIndex(where: { $0.univer.universityID == univer.universityID}) {
            let insertRaw = programs[insertSection].programs.firstIndex(where: { $0.programID > updateProgram.programID}) ?? programs[insertSection].programs.count
            programs[insertSection].programs.insert(updateProgram, at: insertRaw)
        } else {
            let insertSection = programs.firstIndex { $0.univer.universityID > univer.universityID} ?? self.programs.count
            let newElement = ProgramsByUniversityModel(
                univer: univer,
                programs: [updateProgram]
            )
            programs.insert(newElement, at: insertSection)
        }
        removedPrograms[updateProgram.programID] = nil
        
        let response = FavoritePrograms.Load.Response(programs: programs)
        presenter?.presentLoadPrograms(with: response)
    }
    
    func dislikeProgram(at indexPath: IndexPath) {
        let program = programs[indexPath.section].programs.remove(at: indexPath.row)
        let univer = programs[indexPath.section].univer
        removedPrograms[program.programID] = (univer, program)
        if programs[indexPath.section].programs.isEmpty {
            programs.remove(at: indexPath.section)
        }
    }
    
    func handleBatchError(programID: Int) {
        if let (univer, program) = removedPrograms[programID] {
            if let insertSection = programs.firstIndex(where: { $0.univer.universityID == univer.universityID}) {
                let insertRaw = programs[insertSection].programs.firstIndex(where: { $0.programID > program.programID}) ?? programs[insertSection].programs.count
                programs[insertSection].programs.insert(program, at: insertRaw)
            } else {
                let insertSection = programs.firstIndex { $0.univer.universityID > univer.universityID} ?? self.programs.count
                let newElement = ProgramsByUniversityModel(
                    univer: univer,
                    programs: [program]
                )
                programs.insert(newElement, at: insertSection)
            }
        } else {
            if let index = findIndexPath(programID: programID) {
                programs[index.section].programs.remove(at: index.row)
            }
        }
        
        let response = FavoritePrograms.Load.Response(programs: programs)
        presenter?.presentLoadPrograms(with: response)
    }
    
    private func findIndexPath(programID: Int) -> IndexPath? {
        for (section, program) in programs.enumerated() {
            if let index = program.programs.firstIndex(where: {
                $0.programID == programID
            }) {
                return IndexPath(row: index, section: section)
            }
        }
        return nil
    }
    
    func handleBatchSuccess(programID: Int, isFavorite: Bool) {
        if !isFavorite {
            removedPrograms[programID] = nil
        }
    }
    
    func isFavorite(programID: Int, serverValue: Bool) -> Bool {
        favoritesManager.isProgramFavorited(
            programID: programID,
            serverValue: serverValue
        )
    }
}

