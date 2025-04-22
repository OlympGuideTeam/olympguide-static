//
//  DiplomaAssembly.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 21.04.2025.
//

import UIKit

final class DiplomaAssembly {
    static func build(with olympiad: OlympiadModel) -> UIViewController {
        let viewController = DiplomaViewController(with: olympiad)
        let presenter = OlympiadPresenter()
        let interactor = OlympiadInteractor()
        let worker = OlympiadWorker()
        let router = OlympiadRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.dataStore = interactor
        router.viewController = viewController
        
        return viewController
    }
}
