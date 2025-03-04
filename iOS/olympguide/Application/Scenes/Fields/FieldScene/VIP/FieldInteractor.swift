//
//  FieldInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

final class FieldInteractor: FieldBusinessLogic {
    var presenter: FieldPresentationLogic?
    var worker: FieldWorkerLogic = FieldWorker()
    
    func loadPrograms(with request: Field.LoadPrograms.Request) {
        
    }
}

