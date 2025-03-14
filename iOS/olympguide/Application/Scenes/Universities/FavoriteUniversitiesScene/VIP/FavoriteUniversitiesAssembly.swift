//
//  FavoriteUniversitiesAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit

final class FavoriteUniversitiesAssembly {
    static func build() -> UIViewController {
        let viewController = FavoriteUniversitiesViewController()
        let interactor = FavoriteUniversitiesInteractor()
        let presenter = UniversitiesPresenter()
        let router = UniversitiesRouter()
        let worker = FavoriteUniversitiesWorker()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
        interactor.worker = worker
        
        return viewController
    }
}
