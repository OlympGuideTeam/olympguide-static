//
//  Presenter.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit

final class FavoriteProgramsPresenter : FavoriteProgramsPresentationLogic {
    weak var viewController: (FavoriteProgramsDisplayLogic & UIViewController)?
    
    func presentLoadPrograms(with response: FavoritePrograms.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
        }
        
        guard let programs = response.programs else { return }
        
        let viewPrograms  = programs.map { $0.toViewModel() }
        
        let viewModel = FavoritePrograms.Load.ViewModel(programs: viewPrograms)
        viewController?.displayLoadProgramsResult(with: viewModel)
    }
    
    func presentSetFavorite(at indexPath: IndexPath) {
        viewController?.displaySetFavoriteResult(at: indexPath)
    }
}
