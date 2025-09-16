//
//  DiplomaAssembly.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 21.04.2025.
//

import UIKit

final class DiplomaAssembly {
    static func build(with diploma: DiplomaModel) -> UIViewController {
        let viewController = DiplomaViewController(with: diploma)
        let presenter = DiplomaPresenter()
        let interactor = DiplomaInteractor()
        let worker = DiplomaWorker()
        let router = DiplomaRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        interactor.diploma = diploma
        presenter.viewController = viewController
        router.dataStore = interactor
        router.viewController = viewController
        
        return viewController
    }
}
