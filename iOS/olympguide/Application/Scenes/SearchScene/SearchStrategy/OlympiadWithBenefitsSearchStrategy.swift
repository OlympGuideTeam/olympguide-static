//
//  OlympiadWithBenefitsSearchStrategy.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

import UIKit

final class OlympiadWithBenefitsSearchStrategy: SearchStrategy {
    typealias ModelType = OlympiadWithBenefitsModel
    typealias ViewModelType = OlympiadWithBenefitViewModel
    typealias ResponseType = OlympiadWithBenefitsModel
    static var searchTitle: String = "Поиск по льготам"
    
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
            OlympiadTableViewCell.self,
            forCellReuseIdentifier: OlympiadTableViewCell.identifier
        )
    }
    
    
    func configureCell(tableView: UITableView, indexPath: IndexPath, viewMmodel: OlympiadWithBenefitViewModel, isSeparatorHidden: Bool) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OlympiadTableViewCell.identifier, for: indexPath) as? OlympiadTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewMmodel)
        cell.hideSeparator(isSeparatorHidden)
        
        return cell
    }
    
    func titleForItem(_ model: OlympiadWithBenefitsModel) -> String {
        model.olympiad.name
    }
    
    func responseTypeToModel(_ response: [OlympiadWithBenefitsModel]) -> [OlympiadWithBenefitsModel] {
        response
    }
    
    static func modelToViewModel(_ model: [OlympiadWithBenefitsModel]) -> [OlympiadWithBenefitViewModel] {
        model.flatMap { $0.toViewModel() }
    }
    
    static func build(with model: OlympiadWithBenefitsModel) -> UIViewController {
        UIViewController()
    }
}
