//
//  UniversitiesPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

final class UniversitiesPresenter: UniversitiesPresentationLogic {
    weak var viewController: (UniversitiesDisplayLogic & UIViewController)?

    func presentUniversities(with response: Universities.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
            return
        }
        
        guard let universities = response.universities else { return }
        let viewModels = universities.map { $0.toViewModel() }
        
        let viewModel = Universities.Load.ViewModel(universities: viewModels)
        viewController?.displayUniversities(with: viewModel)
    }

    func presentSetFavorite(at index: Int, isFavorite: Bool) {
        viewController?.displaySetFavorite(at: index, isFavorite: isFavorite)
    }
}
