//
//  FieldSearchStrategy.swift
//  olympguide
//
//  Created by Tom Tim on 03.03.2025.
//

import UIKit

final class FieldSearchStrategy: SearchStrategy {
    typealias ModelType = GroupOfFieldsModel.FieldModel
    typealias ViewModelType = FieldViewModel
    typealias ResponseType = GroupOfFieldsModel
    
    static var searchTitle: String = "Поиск по направления"
    
    func endpoint() -> String {
        "/fields"
    }
    
    func queryItems(for query: String) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "search", value: query.trim()))
        return queryItems
    }
    
    func registerCells(in tableView: UITableView) {
        tableView.register(
            FieldTableViewCell.self,
            forCellReuseIdentifier: FieldTableViewCell.identifier
        )
    }
    
    func configureCell(
        tableView: UITableView,
        indexPath: IndexPath,
        viewMmodel: FieldViewModel,
        isSeparatorHidden: Bool = false
    ) -> UITableViewCell {
        let identifier = FieldTableViewCell.identifier
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? FieldTableViewCell
        else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }
        
        cell.configure(with: viewMmodel)
        cell.leftConstraint = 20
        return cell
    }
    
    func titleForItem(_ model: GroupOfFieldsModel.FieldModel) -> String {
        model.name
    }
    
    func modelToViewModel(
        _ model: [GroupOfFieldsModel.FieldModel]
    ) -> [FieldViewModel] {
        model.map { field in
            FieldViewModel(
                name: field.name,
                code: field.code
            )
        }
    }
    
    func build(with model: GroupOfFieldsModel.FieldModel) -> (UIViewController?, PresentMethod?) {
        let vc = FieldAssembly.build(for: model)
        
        return (vc, .push)
    }
    
    func responseTypeToModel(_ response: [GroupOfFieldsModel]) -> [GroupOfFieldsModel.FieldModel] {
        response.flatMap { $0.fields }
    }
}
