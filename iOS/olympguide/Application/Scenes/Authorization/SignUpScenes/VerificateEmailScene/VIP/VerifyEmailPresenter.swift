//
//  EnterEmailPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import Foundation
import UIKit

final class VerifyEmailPresenter: VerifyEmailPresentationLogic {
    
    weak var viewController: (UIViewController & VerifyEmailDisplayLogic)?
    
    func presentVerifyCode(with response: VerifyEmailModels.VerifyCode.Response) {
        if response.success {
            let viewModel = VerifyEmailModels.VerifyCode.ViewModel()
            viewController?.displayVerifyCodeResult(with: viewModel)
        } else {
            if let error = response.error {
                if let networkError = error as? NetworkError,
                   case NetworkError.invalidCode = networkError {
                    let viewModel = VerifyEmailModels.VerifyCode.ViewModel(error: error)
                    viewController?.displayVerifyCodeResult(with: viewModel)
                    return
                }
                viewController?.showAlert(with: error.localizedDescription)
            }
        }
    }
    
    func presentResendCode(with response: VerifyEmailModels.ResendCode.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        let viewModel = VerifyEmailModels.ResendCode.ViewModel()
        viewController?.displayResendCodeResult(with: viewModel)
    }
}
