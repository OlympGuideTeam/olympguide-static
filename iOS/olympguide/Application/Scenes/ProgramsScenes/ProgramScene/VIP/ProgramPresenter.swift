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
        
        let programModel = GroupOfProgramsModel.ProgramModel(
            programID: program.programID,
            name: program.name,
            field: program.field,
            budgetPlaces: program.budgetPlaces,
            paidPlaces: program.paidPlaces,
            cost: program.cost,
            requiredSubjects: program.requiredSubjects,
            optionalSubjects: program.optionalSubjects,
            like: program.like,
            link: program.link ?? ""
        )
        
        let viewModel = Program.Load.ViewModel(program: programModel)
        viewController?.displayLoadProgram(with: viewModel)
    }
}

extension ProgramPresenter : BenefitsByOlympiadsPresentationLogic {
    func presentLoadOlympiads(with response: BenefitsByOlympiads.Load.Response) {
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
        viewController?.displayLoadOlympiadsResult(with: viewModel)
    }
}
