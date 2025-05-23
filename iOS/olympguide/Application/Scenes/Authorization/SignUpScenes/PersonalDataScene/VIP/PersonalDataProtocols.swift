//
//  PersonalDataProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

// MARK: - Business Logic
protocol PersonalDataBusinessLogic {
    func signUp(with request: PersonalData.SignUp.Request)
}

// MARK: - Presentation Logic
protocol PersonalDataPresentationLogic {
    func presentSignUp(with response: PersonalData.SignUp.Response)
}

// MARK: - Display Logic
protocol PersonalDataDisplayLogic: AnyObject {
    func displaySignUp(with viewModel: PersonalData.SignUp.ViewModel)
}

// MARK: - Routing Logic
protocol PersonalDataRoutingLogic {
    func routeToRoot(email: String, password: String, _: Bool)
}

// MARK: - Data Passing
protocol PersonalDataDataPassing {
    var dataStore: EnterEmailDataStore? { get }
}

protocol ValidationErrorDisplayable: AnyObject {
    var lastNameTextField: HighlightableField { get }
    var nameTextField: HighlightableField { get }
    var secondNameTextField: HighlightableField { get }
    var birthdayPicker: HighlightableField { get }
    var regionTextField: (HighlightableField & RegionDelegateOwner) { get }
    var passwordTextField: HighlightableField { get }
}
