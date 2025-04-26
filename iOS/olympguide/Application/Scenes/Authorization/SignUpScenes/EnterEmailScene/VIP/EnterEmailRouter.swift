//
//  EnterEmailRouter.swift
//  olympguide
//
//  Created by Tom Tim on 21.01.2025.
//

import UIKit

final class EnterEmailRouter: EnterEmailRoutingLogic, EnterEmailDataPassing {
    weak var viewController: UIViewController?
    var dataStore: EnterEmailDataStore?

    func routeToVerifyCode() {
        let email = dataStore?.email
        let time = dataStore?.time
        
        let inputCodeVC = VerifyEmailAssembly.build(email: email ?? "", time: time ?? 180)
        
        viewController?.navigationController?.pushViewController(inputCodeVC, animated: true)
    }
}
