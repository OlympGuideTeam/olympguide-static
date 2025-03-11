//
//  Interactor.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import Foundation

final class FavoriteProgramsInteractor: FavoriteProgramsBusinessLogic, FavoriteProgramsDataStore {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
    var programs: [ProgramsByUniversityModel] = []
    var removedPrograms: [Int: (UniversityModel, ProgramShortModel)] = [:]
    
    var presenter: FavoriteProgramsPresentationLogic?
    var worker: FavoriteProgramsWorkerLogic?
    
    
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
    
    func likeProgram(_ univer: UniversityModel, _ program: ProgramShortModel) {
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
        removedPrograms[program.programID] = nil
        
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
    
    func restoreFavorite(at indexPath: IndexPath) -> Bool {
        programs[indexPath.section].programs[indexPath.row].like
    }
    
    func isFavorite(programID: Int, serverValue: Bool) -> Bool {
        favoritesManager.isProgramFavorited(
            programID: programID,
            serverValue: serverValue
        )
    }
}

