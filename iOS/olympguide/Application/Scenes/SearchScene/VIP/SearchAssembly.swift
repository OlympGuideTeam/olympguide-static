//
//  SearchAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 02.03.2025.
//

import UIKit

final class SearchAssembly<Strategy: SearchStrategy> {
    static func build() -> UIViewController {
        let searchVC = SearchViewController<Strategy>(
            searchType: .olympiads
        )
        
        let strategy = Strategy()
        let worker = GenericSearchWorker<Strategy>(
            strategy: strategy
        )
        let interactor = SearchInteractor<Strategy>(worker: worker)
        let presenter = SearchPresenter<Strategy>()
        let router = SearchRouter<Strategy>()
        
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
