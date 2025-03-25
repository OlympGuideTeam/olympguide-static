//
//  OlympiadsPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

import UIKit

final class OlympiadsPresenter: OlympiadsPresentationLogic {
    weak var viewController: (OlympiadsDisplayLogic & UIViewController)?
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol

    func presentLoadOlympiads(with response: Olympiads.Load.Response) {
        if let error = response.error {
            viewController?.showAlert(with: error.localizedDescription)
        }
        guard let olympiads = response.olympiads else { return }
        let viewModels = olympiads.map {
            var olympiad = $0.toViewModel()
            olympiad.like = favoritesManager.isOlympiadFavorite(
                olympiadId: olympiad.olympiadId,
                serverValue: olympiad.like
            )
            return olympiad
        }
        
        let viewModel = Olympiads.Load.ViewModel(olympiads: viewModels)
        viewController?.displayOlympiads(with: viewModel)
    }
    
    func presentSetFavorite(at index: Int, _ isFavorite: Bool) {
        viewController?.displaySetFavorite(at: index, isFavorite)
    }
}
