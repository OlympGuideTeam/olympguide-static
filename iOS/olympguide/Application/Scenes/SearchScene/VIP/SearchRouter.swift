//
//  SearchRouter.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//


import UIKit

final class SearchRouter<Strategy: SearchStrategy> : SearchRoutingLogic, SearchDataPassing {
    weak var viewController: UIViewController?
    var dataStore: SearchInteractor<Strategy>?
    var strategy: Strategy
    
    init (strategy: Strategy) {
        self.strategy = strategy
    }
    
    func routeToDetails(to index: Int) {
        guard
            let model = dataStore?.currentItems[index] as? Strategy.ModelType
        else { return }
        
        let (detailVC, presentMethod) = strategy.build(with: model)
        guard
            let detailVC = detailVC,
            let presentMethod = presentMethod
        else { return }
        
        switch presentMethod {
        case .push:
            viewController?.navigationController?.pushViewController(detailVC, animated: true)
        case .present:
            viewController?.present(detailVC, animated: true)
        }
    }
}
