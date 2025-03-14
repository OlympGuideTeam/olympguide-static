//
//  UniversityPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import UIKit

final class UniversityPresenter {
    weak var viewController: (ProgramsDisplayLogic & UniversityDisplayLogic & UIViewController)?
}

// MARK: - UniversityPresentationLogic
extension UniversityPresenter : UniversityPresentationLogic {
    func presentLoadUniversity(with response: University.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        guard let site = response.site, let email = response.email else {
            return
        }
        let viewModel = University.Load.ViewModel(site: site, email: email)
        viewController?.displayLoadResult(with: viewModel)
    }
    
    func presentToggleFavorite(with response: University.Favorite.Response) {
        if let error = response.error {
            let viewModel = University.Favorite.ViewModel(errorMessage: error.localizedDescription)
            viewController?.displayToggleFavoriteResult(with: viewModel)
        }
    }
    
    func presentSetFavorite(to isFavorite: Bool) {
        viewController?.displayftSetFavorite(to: isFavorite)
    }
}

// MARK: - ProgramsPresentationLogic
extension UniversityPresenter : ProgramsPresentationLogic {
    func presentLoadPrograms(with response: Programs.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        if let groupsOfPrograms = response.groupsOfPrograms {
            let groupsOfProgramsViewModel = groupsOfPrograms.map {
                $0.toViewModel()
            }
            let viewModel = Programs.Load.ViewModel(groupsOfPrograms: groupsOfProgramsViewModel)
            viewController?.displayLoadProgramsResult(with: viewModel)
        }
    }
    
    func presentSetFavorite(at indexPath: IndexPath, isFavorite: Bool) {
        viewController?.displaySetFavorite(at: indexPath, isFavorite)
    }
}
