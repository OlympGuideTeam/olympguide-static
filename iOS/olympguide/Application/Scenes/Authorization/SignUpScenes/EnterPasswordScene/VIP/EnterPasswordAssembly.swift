//
//  EnterPasswordAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 19.04.2025.
//

import UIKit

final class EnterPasswordAssembly {
    static func build(email: String, token: String, isPasswordChange: Bool = false) -> UIViewController {
        let vc = EnterPasswordViewController(email: email)
        let interactor = EnterPasswordInteractor()
        let presenter = EnterPasswordPresenter()
        let router = EnterPasswordRouter()
        let worker = EnterPasswordWorker(token: token, isPasswordChange: isPasswordChange)
        
        vc.interactor = interactor
        vc.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        router.viewController = vc
        presenter.viewController = vc
        return vc
    }
}
