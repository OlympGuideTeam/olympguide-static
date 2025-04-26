//
//  DiplomasRouter.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit

final class DiplomasRouter: DiplomasRoutingLogic, DiplomasDataPassing {
    weak var viewController: UIViewController?
    var dataStore: DiplomasDataStore?
    
    func routeToAddDiploma() {
        let searchVC = SearchAssembly<AddDiplomasSearchStrategy>.build(with: "/olympiads")
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func routeToDiploma(at index: Int) {
        guard let diplomaModel = dataStore?.diplomas[index] else { return }
        let diplomaVC = DiplomaAssembly.build(with: diplomaModel)
        viewController?.navigationController?.pushViewController(diplomaVC, animated: true)
    }
}

