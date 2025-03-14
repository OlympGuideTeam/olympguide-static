//
//  FieldPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit

final class FieldPresenter : FieldPresentationLogic {
    weak var viewController: (FieldDisplayLogic & UIViewController)?
    
    func presentLoadPrograms(with response: Field.LoadPrograms.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        guard let programs = response.programs else { return }
        
        let viewModel = Field.LoadPrograms.ViewModel(programs: programs.map { $0.toViewModel()} )
        viewController?.displayLoadProgramsResult(with: viewModel)
    }
    
    func presentSetFavorite(at indexPath: IndexPath, _ isFavorite: Bool) {
        viewController?.displaySetFavoriteResult(at: indexPath, isFavorite)
    }
}
