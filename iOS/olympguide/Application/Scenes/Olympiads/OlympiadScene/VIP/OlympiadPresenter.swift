//
//  OlympiadPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit

final class OlympiadPresenter : OlympiadPresentationLogic {
    weak var viewController: (OlympiadDisplayLogic & BenefitsByProgramsDisplayLogic & UIViewController)?
    
    func presentLoadUniversities(with response: Olympiad.LoadUniversities.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        guard let universitites = response.universities else {
            return
        }
        
        let universitiesViewModel = universitites.map {university in
            UniversityViewModel(
                universityID: university.universityID,
                name: university.name,
                logoURL: university.logo,
                region: university.region,
                like: university.like ?? false
            )
        }
        
        let viewModel = Olympiad.LoadUniversities.ViewModel(universities: universitiesViewModel)
        viewController?.displayLoadUniversitiesResult(with: viewModel)
    }
}

extension OlympiadPresenter : BenefitsByProgramsPresentationLogic {
    func presentLoadBenefits(with response: BenefitsByPrograms.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        guard
            let programs = response.programs,
            let section = response.section
        else {
            return
        }
        
        let programsViewModel = programs.map { model in
            let program = BenefitsByPrograms.Load.ViewModel.BenefitViewModel.Program(
                programID: model.program.programID,
                programName: model.program.name,
                field: model.program.field
            )
            
            let benefitInformation = model.benefits.map { benefit in
                BenefitsByPrograms.Load.ViewModel.BenefitViewModel.BenefitInformationViewModel(
                    minClass: benefit.minClass,
                    minDiplomaLevel: benefit.minDiplomaLevel,
                    isBVI: benefit.isBVI,
                    confirmationSubjects: benefit.confirmationSubjects,
                    fullScoreSubjects: benefit.fullScoreSubjects
                )
            }
            
            return BenefitsByPrograms.Load.ViewModel.BenefitViewModel(
                program: program,
                benefitInformation: benefitInformation
            )
        }
        
        let viewModel = BenefitsByPrograms.Load.ViewModel(
            benefits: programsViewModel,
            section: section
        )
        viewController?.displayLoadBenefitsResult(with: viewModel)
    }
}
