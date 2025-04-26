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
        guard let diplomaId = dataStore?.diploma?.id else { return }
        let searchVC = SearchAssembly<BenefitsByDiplomaSearchStrategy>.build(with: "/user/diploma/\(diplomaId)/benefits")
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
}
