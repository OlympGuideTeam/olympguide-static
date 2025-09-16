//
//  AddDiplomaInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 26.04.2025.
//

import Foundation

final class AddDiplomaInteractor: AddDiplomaBusinessLogic {
    var presenter: AddDiplomaPresentationLogic?
    var worker: AddDiplomaWorkerLogic = AddDiplomaWorker()
    var olympiad: OlympiadModel?
    
    func addDiploma(with request: AddDiploma.Request) {
        guard let olympiadId = olympiad?.olympiadID else {
            return
        }
        
        guard
            let diplomaClass = request.diplomaClass,
            let diplomaLevel = request.diplomaLevel
        else {
            var validationErrors: [ValidationError] = []
            if request.diplomaClass == nil {
                validationErrors.append(.emptyClass)
            }
            
            if request.diplomaLevel == nil {
                validationErrors.append(.emptyLevel)
            }
            
            let response = AddDiploma.Response(
                error: AppError.validation(validationErrors) as NSError
            )
            
            self.presenter?.presentAddDiploma(with: response)
            return
        }
        worker.addDiploma(
            olympiadId: olympiadId,
            diplomaClass: diplomaClass,
            diplomaLevel: diplomaLevel
        ) { [weak self] result in
            switch result {
            case .success:
                let response = AddDiploma.Response()
                self?.presenter?.presentAddDiploma(with: response)
            case .failure(let error):
                let response = AddDiploma.Response(error: error)
                self?.presenter?.presentAddDiploma(with: response)
            }
            
        }
    }
}

