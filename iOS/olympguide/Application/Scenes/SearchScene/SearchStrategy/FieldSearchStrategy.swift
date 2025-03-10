//
//  FieldSearchStrategy.swift
//  olympguide
//
//  Created by Tom Tim on 03.03.2025.
//

import UIKit

final class FieldSearchStrategy: SearchStrategy {
    typealias ModelType = GroupOfFieldsModel.FieldModel
    typealias ViewModelType = GroupOfFieldsViewModel.FieldViewModel
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
            SecondFieldTableViewCell.self,
            forCellReuseIdentifier: SecondFieldTableViewCell.identifier
        )
    }
    
    func configureCell(
        tableView: UITableView,
        indexPath: IndexPath,
        viewMmodel: GroupOfFieldsViewModel.FieldViewModel,
        isSeparatorHidden: Bool = false
    ) -> UITableViewCell {
        let identifier = SecondFieldTableViewCell.identifier
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? SecondFieldTableViewCell
        else {
            fatalError("Could not dequeue cell with identifier: \(identifier)")
        }
        
        cell.configure(with: viewMmodel)
        return cell
    }
    
    func titleForItem(_ model: GroupOfFieldsModel.FieldModel) -> String {
        model.name
    }
    
    func modelToViewModel(
        _ model: [GroupOfFieldsModel.FieldModel]
    ) -> [GroupOfFieldsViewModel.FieldViewModel] {
        model.map { field in
            GroupOfFieldsViewModel.FieldViewModel(
                name: field.name,
                code: field.code
            )
        }
    }
    
    func build(with model: GroupOfFieldsModel.FieldModel) -> (UIViewController?, PresentMethod?) {
        (nil, nil)
    }
    
    func responseTypeToModel(_ response: [GroupOfFieldsModel]) -> [GroupOfFieldsModel.FieldModel] {
        response.flatMap { $0.fields }
    }
}
