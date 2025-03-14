//
//  OptionsViewInteractor.swift
//  olympguide
//
//  Created by Tom Tim on 31.01.2025.
//

final class OptionsViewInteractor : OptionsDataStore, OptionsBusinessLogic {
    
    var presenter: OptionsPresentationLogic?
    var options: [DynamicOption] = []
    
    private let worker = OptionsWorker()
    
    func textDidChange(with request: Options.TextDidChange.Request) {
        let results: [Options.TextDidChange.Response.Dependencies] = worker.filter(
            items: options,
            with: request.query
        )
        
        presenter?.presentTextDidChange(with: Options.TextDidChange.Response(options: results))
    }
    
    func loadOptions(with request: Options.FetchOptions.Request) {
        worker.fetchOptions(
            endPoint: request.endPoint
        ) { [weak self] result in
            switch result {
            case .success(let options):
                self?.options = options
                let response = Options.FetchOptions.Response(options: options)
                self?.presenter?.presentFetchOptions(with: response)
            case .failure(let error):
                let response =  Options.FetchOptions.Response(error: error)
                self?.presenter?.presentFetchOptions(with: response)
            }
        }
    }
}
