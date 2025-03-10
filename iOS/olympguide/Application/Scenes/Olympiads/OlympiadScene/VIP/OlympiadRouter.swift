//
//  OlympiadRouter.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit

final class OlympiadRouter: OlympiadRoutingLogic, OlympiadDataPassing {
    weak var viewController: UIViewController?
    var dataStore: OlympiadDataStore?
    
    func routeToProgram(indexPath: IndexPath) {
        guard
            let program = dataStore?.programs?[indexPath.section][indexPath.row].program,
            let universityModel = dataStore?.universities?[indexPath.section]
        else { return }

        let programVC = ProgramAssembly.build(
            for: program.programID,
            name: program.name,
            code: program.field,
            university: universityModel
        )
        
        viewController?.navigationController?.pushViewController(programVC, animated: true)
    }
    
    func routeToSearch(olympiadId: Int) {
        let strategy = ProgramWithBenefitsSearchStrategy()
        strategy.allUniversities = dataStore?.allUniversities
        let searchVC = SearchAssembly<ProgramWithBenefitsSearchStrategy>.build(
            with: "/olympiad/\(olympiadId)/benefits",
            strategy: strategy
        )
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
}

