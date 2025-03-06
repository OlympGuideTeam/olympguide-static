//
//  FieldAssembly.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

import UIKit

final class FieldAssembly {
    static func build(for field: GroupOfFieldsModel.FieldModel) -> UIViewController {
        let viewController = FieldViewController(for: field)
        let interactor = FieldInteractor()
        let presenter = FieldPresenter()
        let router = FieldRouter()
        let worker = FieldWorker()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.dataStore = interactor
        
        return viewController
    }
}
