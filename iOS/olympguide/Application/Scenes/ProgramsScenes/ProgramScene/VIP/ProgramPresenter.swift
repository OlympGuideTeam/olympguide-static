//
//  Presenter.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import UIKit

final class ProgramPresenter {
    weak var viewController: (BenefitsByOlympiadsDisplayLogic & ProgramDisplayLogic & UIViewController)?
}

extension ProgramPresenter : ProgramPresentationLogic {
    func presentToggleFavorite(response: Program.Favorite.Response) {
        
    }
    
    func presentLoadProgram(with response: Program.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        guard let program = response.program else { return }
        
        let programModel = program.toShortModel()
        
        let viewModel = Program.Load.ViewModel(program: programModel)
        viewController?.displayLoadProgram(with: viewModel)
    }
    
    func presentSetFavorite(to isFavorite: Bool) {
        viewController?.displaySetFavorite(to: isFavorite)
    }
}

extension ProgramPresenter : BenefitsByOlympiadsPresentationLogic {
    func presentLoadOlympiads(with response: BenefitsByOlympiads.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        guard let olympiads = response.olympiads else { return }
        
        let benefits = olympiads.flatMap {
            $0.toViewModel()
        }
        
        let viewModel = BenefitsByOlympiads.Load.ViewModel(benefits: benefits)
        viewController?.displayLoadOlympiadsResult(with: viewModel)
    }
}
