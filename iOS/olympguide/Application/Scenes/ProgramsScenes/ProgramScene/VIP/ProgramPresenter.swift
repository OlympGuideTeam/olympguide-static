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
        
        guard let link = response.program?.link else { return }
        
        let viewModel = Program.Load.ViewModel(link: link)
        viewController?.displayLoadProgram(with: viewModel)
    }
}

extension ProgramPresenter : BenefitsByOlympiadsPresentationLogic {
    func presentLoadBenefits(with response: BenefitsByOlympiads.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        guard let olympiads = response.olympiads else { return }
        
        let benefits = olympiads.flatMap { model in
            model.benefits.map { benefit in
                BenefitsByOlympiads.Load.ViewModel.BenefitViewModel(
                    olympiadName: model.olympiad.name,
                    olympiadLevel: model.olympiad.level,
                    olympiadProfile: model.olympiad.profile,
                    minClass: benefit.minClass,
                    minDiplomaLevel: benefit.minDiplomaLevel,
                    isBVI: benefit.isBVI,
                    confirmationSubjects: benefit.confirmationSubjects,
                    fullScoreSubjects: benefit.fullScoreSubjects
                )
            }
        }
        
        let viewModel = BenefitsByOlympiads.Load.ViewModel(benefits: benefits)
        viewController?.displayLoadBenefitsResult(with: viewModel)
    }
}
