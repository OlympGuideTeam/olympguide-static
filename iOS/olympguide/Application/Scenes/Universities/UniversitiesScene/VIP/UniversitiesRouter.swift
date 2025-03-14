//
//  UniversitiesRouter.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

final class UniversitiesRouter: UniversitiesRoutingLogic, UniversitiesDataPassing {
    weak var viewController: UIViewController?
    var dataStore: UniversitiesDataStore?

    func routeToUniversity(for index: Int) {
        guard
            let university = dataStore?.universities[index]
        else { return }
        
        let universityVC = UniversityAssembly.build(for: university)
        viewController?.navigationController?.pushViewController(universityVC, animated: true)
    }
    
    func routeToSearch() {
        let searchVC = SearchAssembly<UniversitySearchStrategy>.build(with: "/universities")
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
}
