//
//  VerifyEmailAssembly.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 25.04.2025.
//

import UIKit

final class VerifyEmailAssembly {
    static func build(email: String, time: Int, isPasswordChange: Bool = false) -> UIViewController {
        let viewController = VerifyEmailViewController(email: email, time: time)
        let interactor = VerifyEmailInteractor()
        let presenter = VerifyEmailPresenter()
        let router = VerifyEmailRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        
        interactor.presenter = presenter
        
        presenter.viewController = viewController
        
        router.viewController = viewController
        router.dataStore = interactor
        router.isPasswordChange = isPasswordChange
        return viewController
    }
}
