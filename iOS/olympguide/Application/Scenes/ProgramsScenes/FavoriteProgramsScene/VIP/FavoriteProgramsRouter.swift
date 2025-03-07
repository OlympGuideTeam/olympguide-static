//
//  Router.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit

final class FavoriteProgramsRouter: FavoriteProgramsRoutingLogic, FavoriteProgramsDataPassing {
    var dataStore: FavoriteProgramsDataStore?
    weak var viewController: UIViewController?
    
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

