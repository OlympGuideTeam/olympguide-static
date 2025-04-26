//
//  EnterPasswordProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

// MARK: - Business Logic
protocol EnterPasswordBusinessLogic {
    func signUp(with request: EnterPassword.SignUp.Request)
}

// MARK: - Presentation Logic
protocol EnterPasswordPresentationLogic {
    func presentSignUp(with response: EnterPassword.SignUp.Response)
}

// MARK: - Display Logic
protocol EnterPasswordDisplayLogic: AnyObject {
    var passwordTextField: CustomPasswordField { get set}
    func displaySignUpResult(with viewModel: EnterPassword.SignUp.ViewModel)
}

// MARK: - Routing Logic
protocol EnterPasswordRoutingLogic {
    func routeToRoot()
}
