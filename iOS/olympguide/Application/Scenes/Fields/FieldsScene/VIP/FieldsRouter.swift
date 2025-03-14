//
//  FieldsRouter.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

final class FieldsRouter: FieldsRoutingLogic, FieldsDataPassing {
    weak var viewController: UIViewController?
    var dataStore: FieldsDataStore?
    
    func routeToField(for indexPath: IndexPath) {
        guard let field = dataStore?.groupsOfFields[indexPath.section].fields[indexPath.row] else { return }
        let fieldVC = FieldAssembly.build(for: field)
        viewController?.navigationController?.pushViewController(fieldVC, animated: true)
    }
    
    func routeToSearch() {
        let searchVC = SearchAssembly<FieldSearchStrategy>.build(with: "/fields")
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
}
