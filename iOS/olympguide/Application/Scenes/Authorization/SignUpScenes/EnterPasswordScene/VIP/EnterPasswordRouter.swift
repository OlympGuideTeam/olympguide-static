//
//  Router.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit

final class EnterPasswordRouter: EnterPasswordRoutingLogic {
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    weak var viewController: UIViewController?
    
    func routeToRoot() {
        authManager.isAuthenticated = true
        
        viewController?.navigationController?.popViewController(animated: true)
    }
}

