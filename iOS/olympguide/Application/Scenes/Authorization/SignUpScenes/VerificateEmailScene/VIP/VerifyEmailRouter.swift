//
//  EnterEmailRouter.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import UIKit

final class VerifyEmailRouter: VerifyEmailRoutingLogic, VerifyEmailDataPassing {
    weak var viewController: UIViewController?
    var dataStore: VerifyEmailDataStore?
    
    func routeToPersonalData() {
        guard
            let token = dataStore?.token
        else { return }
        let personalDataVC = PersonalDataAssembly.build(token: token)
        
        viewController?.navigationController?.pushViewController(personalDataVC, animated: true)
    }
}
