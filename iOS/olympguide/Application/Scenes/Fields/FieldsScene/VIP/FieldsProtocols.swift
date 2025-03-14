//
//  FieldsProtocols.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import Foundation

protocol FieldsBusinessLogic {
    func loadFields(with request: Fields.Load.Request)
}

protocol FieldsPresentationLogic {
    func presentFields(with response: Fields.Load.Response)
}

protocol FieldsDisplayLogic: AnyObject {
    func displayFields(with viewModel: Fields.Load.ViewModel)
}

protocol FieldsRoutingLogic {
    func routeToField(for indexPath: IndexPath)
    func routeToSearch()
}

protocol FieldsDataStore {
    var groupsOfFields: [GroupOfFieldsModel] { get set }
}

protocol FieldsDataPassing {
    var dataStore: FieldsDataStore? { get }
}
