//
//  EnterPasswordInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import Foundation

final class EnterPasswordInteractor: EnterPasswordBusinessLogic {
    var presenter: EnterPasswordPresentationLogic?
    var worker: EnterPasswordWorkerLogic?
    
    func signUp(with request: EnterPassword.SignUp.Request) {
        if !isPasswordValid(with: request.password) {
            let validationErrors: [ValidationError] = [.weakPassword]
            let response = EnterPassword.SignUp.Response(
                error: AppError.validation(validationErrors) as NSError
            )
            presenter?.presentSignUp(with: response)
            return
        }
        worker?.signUp(
            email: request.email,
            password: request.password) {[weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    let response = EnterPassword.SignUp.Response()
                    
                    self.presenter?.presentSignUp(with: response)
                case .failure(let networkError):
                    let response = EnterPassword.SignUp.Response(
                        error: AppError.network(networkError) as NSError
                    )
                    self.presenter?.presentSignUp(with: response)
                }
            }

    }
    
    func isPasswordValid(with password: String?) -> Bool {
        let passwordRegex = #"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z0-9\-_!?]{8,}$"#
        
        guard
            let password = password?.trimmingCharacters(in: .whitespacesAndNewlines),
            !password.isEmpty,
            NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        else {
            return false
        }
        
        return true
    }
}

