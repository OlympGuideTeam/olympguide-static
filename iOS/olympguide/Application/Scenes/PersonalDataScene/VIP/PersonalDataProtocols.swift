//
//  PersonalDataProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

// MARK: - Business Logic
protocol PersonalDataBusinessLogic {
    func signUp(with request: PersonalData.SignUp.Request)
    func sendCode(with request: PersonalData.SendCode.Request)
}

// MARK: - Presentation Logic
protocol PersonalDataPresentationLogic {
    func presentSignUp(with response: PersonalData.SignUp.Response)
    func presentSendCode(with response: PersonalData.SendCode.Response)
}

// MARK: - Display Logic
protocol PersonalDataDisplayLogic: AnyObject {
    func displaySignUp(with viewModel: PersonalData.SignUp.ViewModel)
    func displaySendCodeResult(with viewModel: PersonalData.SendCode.ViewModel)
}

// MARK: - Routing Logic
protocol PersonalDataRoutingLogic {
    func routeToRoot()
    func routeToVerifyCode()
}

// MARK: - Data Passing
protocol PersonalDataDataPassing {
    var dataStore: PersonalDataDataStore? { get }
}

protocol PersonalDataDataStore {
    var user: UserModel? { get set }
    var time: Int? { get }
}

protocol ValidationErrorDisplayable: AnyObject {
    var lastNameTextField: CustomInputDataField { get }
    var nameTextField: CustomInputDataField { get }
    var secondNameTextField: CustomInputDataField { get }
    var birthdayPicker: CustomDatePicker { get }
    var regionTextField: OptionsTextField { get }
    var passwordTextField: CustomPasswordField { get }
}
