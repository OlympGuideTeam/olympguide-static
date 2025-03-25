//
//  FieldPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit

final class FieldPresenter : FieldPresentationLogic {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
    weak var viewController: (FieldDisplayLogic & UIViewController)?
    
    func presentLoadPrograms(with response: Field.LoadPrograms.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        guard let programs = response.programs else { return }
        
        let viewModel = Field.LoadPrograms.ViewModel(
            programs: programs.map {    
                let group = $0.toViewModel()
                for program in group.programs {
                    program.like = favoritesManager.isProgramFavorited(
                        programID: program.programID,
                        serverValue: program.like
                    )
                }
                return group
            })
        viewController?.displayLoadProgramsResult(with: viewModel)
    }
    
    func presentSetFavorite(at indexPath: IndexPath, _ isFavorite: Bool) {
        viewController?.displaySetFavoriteResult(at: indexPath, isFavorite)
    }
}
