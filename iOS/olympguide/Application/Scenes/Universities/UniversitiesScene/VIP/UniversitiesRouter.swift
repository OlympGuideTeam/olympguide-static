//
//  UniversitiesRouter.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

final class UniversitiesRouter: UniversitiesRoutingLogic {
    weak var viewController: UIViewController?

    func routeToDetails(for university: UniversityModel) {
        let universityVC = UniversityAssembly.build(for: university)
//        detailsViewController.university = university
        viewController?.navigationController?.pushViewController(universityVC, animated: true)
    }
    
    func routeToSearch() {
        let searchVC = SearchAssembly<UniversitySearchStrategy>.build(with: "/universities")
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
}
