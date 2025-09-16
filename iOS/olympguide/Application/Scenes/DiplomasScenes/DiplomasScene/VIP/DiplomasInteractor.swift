//
//  DiplomasInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

final class DiplomasInteractor: DiplomasBusinessLogic, DiplomasDataStore {
    var presenter: DiplomasPresentationLogic?
    var worker: DiplomasWorkerLogic?
    
    var diplomas: [DiplomaModel] = []
    
    func loadDiplomas(with request: Diplomas.Load.Request) {
        worker?.fetchDiplomas { [weak self] result in
            switch result {
            case .success(let diplomas):
                self?.diplomas = diplomas
                let response = Diplomas.Load.Response(diplomas: diplomas)
                self?.presenter?.presentLoadDiplomas(with: response)
            case .failure(let error):
                let response = Diplomas.Load.Response(error: error)
                self?.presenter?.presentLoadDiplomas(with: response)
            }
        }
    }
    
    func deleteDiploma(with request: Diplomas.Delete.Request) {
        worker?.deleteDiploma(
            id: diplomas[request.index].id
        ) { [weak self] result in
            switch result {
            case .success:
                self?.presenter?.presentDeleteDiploma(with: .init())
            case .failure(let error):
                if case .decodingError = error as? NetworkError {
                    self?.presenter?.presentDeleteDiploma(with: .init())
                    return
                }
                let response = Diplomas.Delete.Response(error: error)
                self?.presenter?.presentDeleteDiploma(with: response)
            }
        }
    }
    
    func syncDiplomas(with request: Diplomas.Sync.Request) {
        worker?.syncDiplomas { [weak self] result in
            switch result {
            case .success:
                let response = Diplomas.Sync.Response()
                self?.presenter?.presentSyncDiplomas(with: response)
            case .failure(let error):
                let response = Diplomas.Sync.Response(error: error)
                self?.presenter?.presentSyncDiplomas(with: response)
            }
        }
    }
}
