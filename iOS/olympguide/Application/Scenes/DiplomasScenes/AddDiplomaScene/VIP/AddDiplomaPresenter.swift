//
//  AddDiplomaPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 26.04.2025.
//

import UIKit

final class AddDiplomaPresenter : AddDiplomaPresentationLogic {
    weak var viewController: (AddDiplomaDisplayLogic & UIViewController)?
    
    func presentAddDiploma(with response: AddDiploma.Response) {
        if response.error == nil {
            let viewModel = AddDiploma.ViewModel()
            viewController?.displayAddDiplomaResult(with: viewModel)
            return
        }
        guard let error = response.error else { return }
        highlightValidationErrors(error)
        viewController?.showAlert(with: error.localizedDescription)
    }
    
    private func highlightValidationErrors(_ error: Error) {
        guard case AppError.validation(let errors) = error else {
            return
        }
        
        for error in errors {
            switch error {
            case .emptyClass:
                viewController?.classTextField.highlightError()
            case .emptyLevel:
                viewController?.diplomaLevelTextField.highlightError()
            default:
                break
            }
        }
    }
}
