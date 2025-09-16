//
//  ProfileAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

import UIKit

final class ProfileAssembly {
    static func build() -> UIViewController {
        let viewController = ProfileViewController()
        let router = ProfileRouter()
        let interactor = ProfileInteractor()
        let worker = ProfileWorker()
        let presenter = ProfilePresenter()
        viewController.router = router
        router.viewController = viewController
        viewController.interactor = interactor
        interactor.worker = worker
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.dataStore = interactor
        return viewController
    }
}
