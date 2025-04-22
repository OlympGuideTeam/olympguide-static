//
//  PersonalDataRouter.swift
//  olympguide
//
//  Created by Tom Tim on 05.02.2025.
//

import UIKit

final class PersonalDataRouter : PersonalDataRoutingLogic {
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    weak var viewController: UIViewController?
    
    func routeToRoot() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
