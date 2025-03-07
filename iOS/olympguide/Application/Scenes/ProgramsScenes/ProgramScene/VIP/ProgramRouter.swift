//
//  Router.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import UIKit

final class ProgramRouter: ProgramRoutingLogic, ProgramDataPassing {
    weak var viewController: UIViewController?
    var dataStore: ProgramDataStore?
    
    func routeToSearch(programId: Int) {
        let searchVC = SearchAssembly<OlympiadWithBenefitsSearchStrategy>.build(with: "/program/\(programId)/benefits")
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
}

