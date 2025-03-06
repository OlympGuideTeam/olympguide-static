//
//  FieldRouter.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit

final class FieldRouter: FieldRoutingLogic, FieldDataPassing {
    weak var viewController: UIViewController?
    var dataStore: FieldDataStore?
    
    func routeToProgram(indexPath: IndexPath) {
        guard let programs = dataStore?.programs else { return }
        
        let university = programs[indexPath.section].univer
        let program = programs[indexPath.section].programs[indexPath.row]
        
        let programVC = ProgramAssembly.build(
            for: program,
            by: university
        )
        
        viewController?.navigationController?.pushViewController(programVC, animated: true)
    }
}

