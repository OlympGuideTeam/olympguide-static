//
//  SignInProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

// MARK: - Business Logic
protocol SignInBusinessLogic {
    func signIn(with request: SignInModels.SignIn.Request)
}

// MARK: - Presentation Logic
protocol SignInPresentationLogic {
    func presentSignIn(with response: SignInModels.SignIn.Response)
}

// MARK: - Display Logic
protocol SignInDisplayLogic: AnyObject {
    func displaySignInResult(with viewModel: SignInModels.SignIn.ViewModel)
}

// MARK: - Routing Logic
protocol SignInRoutingLogic {
    func routeToRoot()
}

protocol SignInValidationErrorDisplayable {
    var emailTextField: HighlightableField { get }
    var passwordTextField: HighlightableField { get }
}
