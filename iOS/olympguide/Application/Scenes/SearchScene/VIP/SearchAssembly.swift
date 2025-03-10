//
//  SearchAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 02.03.2025.
//

import UIKit

final class SearchAssembly<Strategy: SearchStrategy> {
    static func build(with endpoint: String, strategy: Strategy = Strategy()) -> UIViewController {
        let searchVC = SearchViewController<Strategy>()
        
        let worker = GenericSearchWorker<Strategy>(
            strategy: strategy,
            endpoint: endpoint
        )
        let interactor = SearchInteractor<Strategy>(worker: worker)
        let presenter = SearchPresenter<Strategy>(strategy: strategy)
        let router = SearchRouter<Strategy>(strategy: strategy)
        
        searchVC.interactor = interactor
        searchVC.router = router
        interactor.presenter = presenter
        presenter.viewController = searchVC
        router.viewController = searchVC
        router.dataStore = interactor
        
        searchVC.strategy = strategy
        
        return searchVC
    }
}
