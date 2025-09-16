//
//  DiplomaRouter.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 26.04.2025.
//

import UIKit

final class DiplomaRouter : DiplomaRoutingLogic, DiplomaDataPassing {
    var dataStore: DiplomaDataStore?
    
    weak var viewController: DiplomaViewController?
    
    func routeToSearch() {
        guard
            let diplomaId = dataStore?.diploma?.id,
            let allUniversities = dataStore?.allUniversities
        else { return }
        let strategy = BenefitsByDiplomaSearchStrategy()
        strategy.allUniversities = allUniversities
        let searchVC = SearchAssembly<BenefitsByDiplomaSearchStrategy>.build(
            with: "/user/diploma/\(diplomaId)/benefits",
            strategy: strategy
        )
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
    
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
    
//    let strategy = ProgramWithBenefitsSearchStrategy()
//    strategy.allUniversities = dataStore?.allUniversities
//    let searchVC = SearchAssembly<ProgramWithBenefitsSearchStrategy>.build(
//        with: "/olympiad/\(olympiadId)/benefits",
//        strategy: strategy
//    )
//    viewController?.navigationController?.pushViewController(searchVC, animated: true)
}
