//
//  OlympiadsPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

import UIKit

final class OlympiadsPresenter: OlympiadsPresentationLogic {
    
    weak var viewController: OlympiadsDisplayLogic?

    func presentOlympiads(_ response: Olympiads.Load.Response) {
        
        let viewModels = response.olympiads.map { $0.toViewModel() }
        
        let viewModel = Olympiads.Load.ViewModel(olympiads: viewModels)
        viewController?.displayOlympiads(viewModel)
    }

    func presentError(message: String) {
        viewController?.displayError(message: message)
    }
}
