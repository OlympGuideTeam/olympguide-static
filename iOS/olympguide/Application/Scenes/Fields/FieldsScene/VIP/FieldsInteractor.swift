//
//  FieldsInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

// MARK: - FieldsInteractor
final class FieldsInteractor: FieldsBusinessLogic, FieldsDataStore {
    var presenter: FieldsPresentationLogic?
    var worker: FieldsWorker = FieldsWorker()
    var groupsOfFields: [GroupOfFieldsModel] = []

    func loadFields(with request: Fields.Load.Request) {
        let params: [Param] = request.params.flatMap { key, value in
            value.array
        }
        worker.fetchFields(
            with: params
        ) {
            [weak self] result in
            switch result {
            case .success(let groupsOfFields):
                self?.groupsOfFields = groupsOfFields
                let response = Fields.Load.Response(groupsOfFields: groupsOfFields)
                self?.presenter?.presentFields(with: response)
            case .failure(let error):
                let response = Fields.Load.Response(error: error)
                self?.presenter?.presentFields(with: response)
            }
        }
    }
}

