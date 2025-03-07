//
//  ProgramWithBenefitsSearchStrategy.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

import UIKit

final class ProgramWithBenefitsSearchStrategy: SearchStrategy {
    typealias ModelType = ProgramWithBenefitsModel
    typealias ViewModelType = ProgramWithBenefitsViewModel
    typealias ResponseType = ProgramWithBenefitsModel
    
    static var searchTitle: String = "Поиск по программам"
    
    func endpoint() -> String {
        ""
    }
    
    func queryItems(for query: String) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "search", value: query.trim()))
        return queryItems
    }
    
    func registerCells(in tableView: UITableView) {
        tableView.register(
            UIProgramWithBenefitsCell.self,
            forCellReuseIdentifier: UIProgramWithBenefitsCell.identifier
        )
    }
    
    func configureCell(
        tableView: UITableView,
        indexPath: IndexPath,
        viewMmodel: ProgramWithBenefitsViewModel,
        isSeparatorHidden: Bool
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UIProgramWithBenefitsCell.identifier,
            for: indexPath
        ) as? UIProgramWithBenefitsCell else {
            fatalError("Could not dequeue cell")
        }
        cell.configure(with: viewMmodel, indexPath: indexPath)
        return cell
    }
    
    func titleForItem(_ model: ProgramWithBenefitsModel) -> String {
        model.program.name
    }
    
    func responseTypeToModel(
        _ response: [ProgramWithBenefitsModel]
    ) -> [ProgramWithBenefitsModel] {
        response
    }
    
    static func modelToViewModel(
        _ model: [ProgramWithBenefitsModel]
    ) -> [ProgramWithBenefitsViewModel] {
        model.map { $0.toViewModel() }
    }
    
    static func build(with model: ProgramWithBenefitsModel) -> UIViewController {
        UIViewController()
    }
}
