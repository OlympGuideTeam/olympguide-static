//
//  EnterEmailRouter.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import UIKit

final class VerifyEmailRouter: VerifyEmailRoutingLogic, VerifyEmailDataPassing {
    @InjectSingleton
    var authManager: AuthManagerProtocol
    weak var viewController: UIViewController?
    var dataStore: VerifyEmailDataStore?
    
    func routeToPersonalData() {
        guard
            let token = dataStore?.token
        else { return }
        let email  = authManager.userEmail ?? ""
        let personalDataVC = EnterPasswordAssembly.build(email: email, token: token)
        
        viewController?.navigationController?.pushViewController(personalDataVC, animated: true)
    }
}
