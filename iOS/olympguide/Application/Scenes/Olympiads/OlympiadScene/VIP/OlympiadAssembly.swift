//
//  OlympiadAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 02.03.2025.
//

import UIKit

final class OlympiadAssembly {
    static func build(with olympiad: OlympiadModel) -> UIViewController {
        let viewController = OlympiadViewController(with: olympiad)
        let presenter = OlympiadPresenter()
        let interactor = OlympiadInteractor()
        let worker = OlympiadWorker()
        let router = OlympiadRouter()
        
        viewController.inteactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
//        router.dataStore = interactor
        
        return viewController
    }
}
