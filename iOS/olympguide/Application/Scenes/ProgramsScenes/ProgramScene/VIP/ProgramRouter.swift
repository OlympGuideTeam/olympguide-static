//
//  Router.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import UIKit

final class ProgramRouter: ProgramRoutingLogic {
    weak var viewController: UIViewController?
    
    func routeToSearch(programId: Int) {
        let searchVC = SearchAssembly<OlympiadWithBenefitsSearchStrategy>.build(with: "/program/\(programId)/benefits")
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func routToBenefit(_ benefit: OlympiadWithBenefitViewModel) {
        let detailVC = BenefitViewController(with: benefit)
        viewController?.present(detailVC, animated: true)
    }
}

