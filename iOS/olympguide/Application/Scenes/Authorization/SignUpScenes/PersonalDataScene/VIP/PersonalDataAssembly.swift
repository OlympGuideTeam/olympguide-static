//
//  PersonalDataAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 18.02.2025.
//

import UIKit

class PersonalDataAssembly {
    static func build(token: String, isGoogleSignUp: Bool = false) -> UIViewController {
        let presenter = PersonalDataPresenter()
        let interactor = PersonalDataInteractor()
        interactor.presenter = presenter
        let view = PersonalDataViewController(
            token: token,
            isGoogleSignUp: isGoogleSignUp
        )
        view.interactor = interactor
        let router = PersonalDataRouter()
        router.viewController = view
        view.router = router
        presenter.viewController = view
        return view
    }
}
