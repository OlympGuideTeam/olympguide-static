//
//  AddDiplomaAssembly.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 25.04.2025.
//

import UIKit

final class AddDiplomaAssembly {
    static func build(with olympiad: OlympiadModel) -> UIViewController {
        let viewController = AddDiplomaViewController(with: olympiad)
        let interactor = AddDiplomaInteractor()
        let presenter = AddDiplomaPresenter()
        let router = AddDiplomaRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.olympiad = olympiad
        presenter.viewController = viewController
        router.viewController = viewController
        
        return viewController
    }
}
