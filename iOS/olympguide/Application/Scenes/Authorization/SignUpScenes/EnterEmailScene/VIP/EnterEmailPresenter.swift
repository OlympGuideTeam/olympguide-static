//
//  EnterEmailPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import UIKit

final class EnterEmailPresenter: EnterEmailPresentationLogic {
    
    weak var viewController: (EnterEmailDisplayLogic & UIViewController)?
    
    func presentSendCode(with response: EnterEmailModels.SendCode.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        let viewModel = EnterEmailModels.SendCode.ViewModel()
        viewController?.displaySendCodeResult(with: viewModel)
    }
}
