//
//  VerifyEmailProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation
import UIKit

// MARK: - Business Logic
protocol VerifyEmailBusinessLogic {
    func verifyCode(with request: VerifyEmailModels.VerifyCode.Request)
    func resendCode(with request: VerifyEmailModels.ResendCode.Request)
}

// MARK: - Data Store
protocol VerifyEmailDataStore {
    var token: String? { get set }
    var time: Int? { get set }
}

// MARK: - Presentation Logic
protocol VerifyEmailPresentationLogic {
    func presentVerifyCode(with response: VerifyEmailModels.VerifyCode.Response)
    func presentResendCode(with response: VerifyEmailModels.ResendCode.Response)
}

// MARK: - Display Logic
protocol VerifyEmailDisplayLogic: AnyObject {
    func displayVerifyCodeResult(with viewModel: VerifyEmailModels.VerifyCode.ViewModel)
    func displayResendCodeResult(with viewModel: VerifyEmailModels.ResendCode.ViewModel)
}

// MARK: - Routing Logic
protocol VerifyEmailRoutingLogic {
    func routeToEnterPassword()
}

// MARK: - Data Passing
protocol VerifyEmailDataPassing {
    var dataStore: VerifyEmailDataStore? { get }
}
