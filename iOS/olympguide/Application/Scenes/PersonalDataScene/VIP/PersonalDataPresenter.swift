//
//  PersonalDataPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

final class PersonalDataPresenter : PersonalDataPresentationLogic {
    weak var viewController: (PersonalDataDisplayLogic & ValidationErrorDisplayable)?
    
    func presentSignUp(with response: PersonalData.SignUp.Response) {
        if response.error == nil {
            let viewModel = PersonalData.SignUp.ViewModel(errorMessage: nil)
            viewController?.displaySignUp(with: viewModel)
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
        
        let viewModel = PersonalData.SignUp.ViewModel(errorMessage: errorMessages)
        viewController?.displaySignUp(with: viewModel)
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
            case .invalidLastName:
                viewController?.lastNameTextField.highlightError()
            case .invalidFirstName:
                viewController?.nameTextField.highlightError()
            case .invalidSecondName:
                viewController?.secondNameTextField.highlightError()
            case .invalidBirthay:
                viewController?.birthdayPicker.highlightError()
            case .invalidRegion:
                viewController?.regionTextField.highlightError()
            default:
                break
            }
        }
    }
}
