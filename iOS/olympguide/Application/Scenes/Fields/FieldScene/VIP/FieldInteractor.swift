//
//  FieldInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import Foundation

final class FieldInteractor: FieldBusinessLogic, FieldDataStore {
    var presenter: FieldPresentationLogic?
    var worker: FieldWorkerLogic?
    var programs: [ProgramsByUniversityModel]?
    
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
    
    func restoreFavorite(at indexPath: IndexPath) -> Bool {
        programs?[indexPath.section].programs[indexPath.row].like ?? false
    }
    
    func setFavorite(to programId: Int, isFavorite: Bool) {
        guard
            let indexPath = getIndexPath(to: programId)
        else { return }
        
        programs?[indexPath.section].programs[indexPath.row].like = isFavorite
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
    
    func getProgram(at indexPath: IndexPath) -> ProgramShortModel? {
        programs?[indexPath.section].programs[indexPath.row]
    }
    func getUniversity(at index: Int) -> UniversityModel? {
        programs?[index].univer
    }
}

