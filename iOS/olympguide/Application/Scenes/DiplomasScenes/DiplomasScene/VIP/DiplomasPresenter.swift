//
//  DiplomasPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit

final class DiplomasPresenter : DiplomasPresentationLogic {
    weak var viewController: (DiplomasDisplayLogic & UIViewController)?
    
    func presentLoadDiplomas(with response: Diplomas.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
        }
        
        guard let diplomas = response.diplomas else { return }
        
        let diplomasViewModel = diplomas.map { $0.toViewModel() }
        let viewModel = Diplomas.Load.ViewModel(diplomas: diplomasViewModel)
        viewController?.displayLoadDiplomasResult(with: viewModel)
    }
    
    func presentDeleteDiploma(with response: Diplomas.Delete.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
        }
    }
}
