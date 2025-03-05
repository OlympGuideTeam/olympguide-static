//
//  FieldsRouter.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

final class FieldsRouter: FieldsRoutingLogic {
    weak var viewController: UIViewController?

    func routeToDetails(for field: GroupOfFieldsModel.FieldModel) {
        let detailsViewController = FieldViewController(for: field) 
        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func routeToSearch() {
        let searchVC = SearchAssembly<FieldSearchStrategy>.build()
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
}
