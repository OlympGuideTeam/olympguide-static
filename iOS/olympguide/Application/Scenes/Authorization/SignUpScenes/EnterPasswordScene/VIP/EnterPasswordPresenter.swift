//
//  Presenter.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit

final class EnterPasswordPresenter : EnterPasswordPresentationLogic {
    weak var viewController: (EnterPasswordDisplayLogic & UIViewController)?
    
    func presentSignUp(with response: EnterPassword.SignUp.Response) {
        if response.error == nil {
            let viewModel = EnterPassword.SignUp.ViewModel()
            viewController?.displaySignUpResult(with: viewModel)
            return
        }
        
        var errorMessages: [String] = []
        
        if let error = response.error as? AppError {
            switch error {
            case .network(let networkError):
                errorMessages.append(networkError.localizedDescription)
            case .validation(let validationErrors):
                errorMessages.append(contentsOf: validationErrors.map { $0.localizedDescription })
                highlightValidationErrors(validationErrors)
            }
        } else {
            errorMessages.append("Произошла неизвестная ошибка")
        }
        
        let errorMessage = errorMessages[0]
        
        viewController?.showAlert(with: errorMessage)
    }
    
    private func highlightValidationErrors(_ errors: [ValidationError]) {
        for error in errors {
            switch error {
            case .emptyField(let fieldName):
                if fieldName.lowercased() == "пароль" {
                    viewController?.passwordTextField.highlightError()
                }
            case .weakPassword, .shortPassword, .passwordWithoutLowercaseLetter, .passwordWithoutUpperrcaseLetter, .passwordWithoutDigit:
                viewController?.passwordTextField.highlightError()
            default:
                break
            }
        }
    }
}
