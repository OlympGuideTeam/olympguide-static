//
//  OptionsViewProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 31.01.2025.
//

// MARK: - DataStore
protocol OptionsDataStore {
    var items: [OptionModel] { get set }
    var results: [OptionModel] { get set }
}

// MARK: - ViewController → Interactor
protocol OptionsBusinessLogic {
    func textDidChange(request: Options.TextDidChange.Request)
}

// MARK: - Presenter → ViewController
protocol OptionsDisplayLogic: AnyObject {
    func displayTextDidChange(viewModel: Options.TextDidChange.ViewModel)
}

// MARK: - Interactor → Presenter
protocol OptionsPresentationLogic {
    func presentTextDidChange(response: Options.TextDidChange.Response)
}
