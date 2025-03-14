//
//  OlympiadWithBenefitsSearchStrategy.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

import UIKit

final class OlympiadWithBenefitsSearchStrategy: SearchStrategy {
    typealias ModelType = OlympiadWithBenefitViewModel
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
    
    
    func configureCell(
        tableView: UITableView,
        indexPath: IndexPath,
        viewMmodel: OlympiadWithBenefitViewModel,
        isSeparatorHidden: Bool
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: OlympiadTableViewCell.identifier,
                for: indexPath
            ) as? OlympiadTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewMmodel)
        cell.hideSeparator(isSeparatorHidden)
        
        return cell
    }
    
    func titleForItem(_ model: OlympiadWithBenefitViewModel) -> String {
        model.olympiadName
    }
    
    func responseTypeToModel(
        _ response: [OlympiadWithBenefitsModel]
    ) -> [OlympiadWithBenefitViewModel] {
        response.flatMap { $0.toViewModel() }
    }
    
    func modelToViewModel(
        _ model: [OlympiadWithBenefitViewModel]
    ) -> [OlympiadWithBenefitViewModel] {
        model
    }
    
    func build(
        with model: OlympiadWithBenefitViewModel
    ) -> (UIViewController?, PresentMethod?) {
        (BenefitViewController(with: model), .present)
    }
}
