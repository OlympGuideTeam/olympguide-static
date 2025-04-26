//
//  PersonalDataAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 18.02.2025.
//

import UIKit

class PersonalDataAssembly {
    static func build(with user: UserModel) -> UIViewController {
        let presenter = PersonalDataPresenter()
        let interactor = PersonalDataInteractor()
        interactor.presenter = presenter
        let view = PersonalDataViewController(with: user.toViewModel())
        view.interactor = interactor
        let router = PersonalDataRouter()
        interactor.user = user
        router.viewController = view
        view.router = router
        presenter.viewController = view
        router.dataStore = interactor
        return view
    }
}
