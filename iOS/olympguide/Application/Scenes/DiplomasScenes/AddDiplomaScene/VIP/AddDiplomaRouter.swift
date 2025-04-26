//
//  AddDiplomaRouter.swift
//  olympguide
//
//  Created by Tom Tim on 26.04.2025.
//

import UIKit

final class AddDiplomaRouter : AddDiplomaRoutingLogic {
    weak var viewController: UIViewController?
    func routeToRoot() {
        if
            let viewController = viewController,
            let navigationController = viewController.navigationController {
            let viewControllers = navigationController.viewControllers
            if let rootViewController = viewControllers.first {
                navigationController.setViewControllers([rootViewController, viewController], animated: true)
            }
        }
        
        viewController?.navigationController?.popViewController(animated: true)
    }
}
