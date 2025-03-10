//
//  FieldInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

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
}

