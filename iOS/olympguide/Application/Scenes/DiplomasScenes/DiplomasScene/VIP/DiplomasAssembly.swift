//
//  DiplomasAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 24.03.2025.
//

import UIKit

final class DiplomasAssembly {
    static func build() -> UIViewController {
        let viewController = DiplomasViewController()
        let interactor = DiplomasInteractor()
        let worker = DiplomasWorker()
        let presenter = DiplomasPresenter()
        let router = DiplomasRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        return viewController
    }
}
