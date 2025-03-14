//
//  EnterEmailProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

// MARK: - Business Logic
protocol EnterEmailBusinessLogic {
    func sendCode(with request: EnterEmailModels.SendCode.Request)
}

// MARK: - Data Store
protocol EnterEmailDataStore {
    var email: String? { get set }
    var time: Int? { get set }
}

// MARK: - Presentation Logic
protocol EnterEmailPresentationLogic {
    func presentSendCode(with response: EnterEmailModels.SendCode.Response)
}

// MARK: - Display Logic
protocol EnterEmailDisplayLogic: AnyObject {
    func displaySendCodeResult(with viewModel: EnterEmailModels.SendCode.ViewModel)
}

// MARK: - Routing Logic
protocol EnterEmailRoutingLogic {
    func routeToVerifyCode()
}

// MARK: - Data Passing
protocol EnterEmailDataPassing {
    var dataStore: EnterEmailDataStore? { get }
}
