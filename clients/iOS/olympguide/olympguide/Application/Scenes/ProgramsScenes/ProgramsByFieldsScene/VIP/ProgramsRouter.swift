//
//  DirectionsRouter.swift
//  olympguide
//
//  Created by Tom Tim on 24.02.2025.
//

import Foundation
import UIKit

final class ProgramsRouter: ProgramsRoutingLogic, ProgramsDataPassing {
    var dataStore: ProgramsDataStore?
    weak var viewController: UIViewController?
    
    func routeToProgram() {
        
    }
    
    func routeToSearch() {
        let searchVC = SearchViewController(searchType: .fields)
        searchVC.modalPresentationStyle = .overFullScreen
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
}

