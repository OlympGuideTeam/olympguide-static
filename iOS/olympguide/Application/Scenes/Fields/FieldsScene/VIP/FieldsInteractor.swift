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

    func loadFields(_ request: Fields.Load.Request) {
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
                self?.presenter?.presentFields(response: response)
            case .failure(let error):
                self?.presenter?.presentError(message: error.localizedDescription)
            }
        }
    }
}

