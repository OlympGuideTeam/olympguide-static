//
//  SearchRouter.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//


import UIKit

final class SearchRouter<Strategy: SearchStrategy>: SearchRoutingLogic, SearchDataPassing {
    weak var viewController: UIViewController?
    var dataStore: SearchInteractor<Strategy>?
    
    func routeToDetails(to index: Int) {
        guard
            let model = dataStore?.currentItems[index] as? Strategy.ModelType
        else { return }
        
        let detailVC = Strategy.build(with: model)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
