//
//  SearchProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//

import UIKit

// MARK: - ViewController → Interactor
protocol SearchBusinessLogic {
    func textDidChange(request: Search.TextDidChange.Request)
}

// MARK: - Interactor → Presenter
protocol SearchPresentationLogic {
    func presentTextDidChange<ResponseModel>(response: Search.TextDidChange.Response<ResponseModel>)
}

// MARK: - Presenter → ViewController
protocol SearchDisplayLogic: AnyObject {
    func displayTextDidChange<ViewModel>(viewModel: Search.TextDidChange.ViewModel<ViewModel>)
}

// MARK: - Router Logic
protocol SearchRoutingLogic {
    func routeToDetails(to index: Int)
}

// MARK: - DataStore
protocol SearchDataStore {
    associatedtype ItemType
    var currentItems: [ItemType] { get }
}

// MARK: - Data Passing
protocol SearchDataPassing {
    associatedtype DataStoreType: SearchDataStore
    var dataStore: DataStoreType? { get }
}
