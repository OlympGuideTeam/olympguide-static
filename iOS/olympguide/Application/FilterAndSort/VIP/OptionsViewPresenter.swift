//
//  OptionsViewPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 31.01.2025.
//

import Foundation

final class OptionViewPresenter : OptionsPresentationLogic {
    weak var viewController: OptionsDisplayLogic?
    
    func presentTextDidChange(response: Options.TextDidChange.Response) {
        let viewModels = response.options.map { option in
            Options.TextDidChange.ViewModel.DependenciesViewModel(
                realIndex: option.realIndex,
                currentIndex: option.currentIndex
            )
        }
        
        let viewModel = Options.TextDidChange.ViewModel(dependencies: viewModels)
        viewController?.displayTextDidChange(viewModel: viewModel)
    }
    
    func presentFetchOptions(response: Options.FetchOptions.Response) {
        if let error = response.error {
            let viewModel = Options.FetchOptions.ViewModel(error: error)
            viewController?.displayFetchOptions(viewModel: viewModel)
            return
        }
        
        guard let options = response.options else { return }
        
        let viewModels = options.map { option in
            OptionViewModel(
                id: option.id,
                name: option.name
            )
        }
        
        let viewModel = Options.FetchOptions.ViewModel(options: viewModels)
        viewController?.displayFetchOptions(viewModel: viewModel)
    }
    
    func presentError(message: String) {
        viewController?.showAlert(with: message)
    }
}
