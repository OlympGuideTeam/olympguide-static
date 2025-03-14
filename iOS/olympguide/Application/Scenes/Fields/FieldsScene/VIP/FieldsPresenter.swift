//
//  FieldsPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

final class FieldsPresenter: FieldsPresentationLogic {
    weak var viewController: (FieldsDisplayLogic & UIViewController)?
    
    func presentFields(with response: Fields.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
        }
        guard let groupsOfFields = response.groupsOfFields else { return }
        let viewModels = groupsOfFields.map { $0.toViewModel() }
        
        let viewModel = Fields.Load.ViewModel(groupsOfFields: viewModels)
        viewController?.displayFields(with: viewModel)
    }
}
