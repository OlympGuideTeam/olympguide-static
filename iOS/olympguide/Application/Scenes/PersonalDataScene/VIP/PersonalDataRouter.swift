//
//  PersonalDataRouter.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

import UIKit

final class PersonalDataRouter : PersonalDataRoutingLogic, PersonalDataDataPassing  {
    @InjectSingleton
    var authManager: AuthManagerProtocol
    var dataStore: (any PersonalDataDataStore)?
    
    weak var viewController: UIViewController?
    
    func routeToRoot() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func routeToVerifyCode() {
        guard
            let email = dataStore?.user?.email
        else {
            return
        }
        authManager.userEmail = email
        let inputCodeVC = VerifyEmailAssembly.build(email: email, time: dataStore?.time ?? 180, isPasswordChange: true)
        
        viewController?.navigationController?.pushViewController(inputCodeVC, animated: true)
    }
}
