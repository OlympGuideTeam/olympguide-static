//
//  UniversityRouter.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import UIKit

final class UniversityRouter : UniversityDataPassing, ProgramsDataPassing {
    var dataStore: (UniversityDataStore & ProgramsDataStore)?
    
    var universityDataStore: UniversityDataStore? {
        get { dataStore }
        set { dataStore = newValue as? (UniversityDataStore & ProgramsDataStore) }
    }
    
    var programsDataStore: ProgramsDataStore? {
        get { dataStore }
        set { dataStore = newValue as? (UniversityDataStore & ProgramsDataStore) }
    }
    
    weak var viewController: UIViewController?
}

extension UniversityRouter : ProgramsRoutingLogic {
    func routeToProgram(with indexPath: IndexPath) {
        guard
            let university = programsDataStore?.university,
            let groupsOfPrograms = programsDataStore?.groupsOfPrograms
        else { return }
        
        let program = groupsOfPrograms[indexPath.section].programs[indexPath.row]
        
        let programVC = ProgramAssembly.build(
            for: program,
            by: university
        )
        
        viewController?.navigationController?.pushViewController(programVC, animated: true)
    }
    
    func routeToSearch() {
        let strategy = ProgramInUniSearchStrategy()
        strategy.university = programsDataStore?.university
        let searchVC = SearchAssembly<ProgramInUniSearchStrategy>.build(
            with: "/university/1/programs/by-field",
            strategy: strategy
        )
        
        searchVC.modalPresentationStyle = .overFullScreen
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
}

