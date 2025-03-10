//
//  SearchPresenter.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//

import Foundation

final class SearchPresenter<Strategy: SearchStrategy>: SearchPresentationLogic {
    
    weak var viewController: SearchDisplayLogic?
    var strartegy: Strategy
    
    init(strategy: Strategy) {
        self.strartegy = strategy
    }
    
    func presentTextDidChange<ResponseModel>(response: Search.TextDidChange.Response<ResponseModel>) {
        
        guard let items = response.items as? [Strategy.ModelType] else {
            let vm = Search.TextDidChange.ViewModel(items: [])
            viewController?.displayTextDidChange(viewModel: vm)
            return
        }
        
        let viewItems = strartegy.modelToViewModel(items)
        let viewModel = Search.TextDidChange.ViewModel(items: viewItems)
        viewController?.displayTextDidChange(viewModel: viewModel)
    }
}
