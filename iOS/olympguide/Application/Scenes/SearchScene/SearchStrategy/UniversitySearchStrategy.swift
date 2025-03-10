//
//  UniversitySearchStrategy.swift
//  olympguide
//
//  Created by Tom Tim on 03.03.2025.
//

import UIKit

final class UniversitySearchStrategy: SearchStrategy {
    typealias ModelType = UniversityModel
    typealias ViewModelType = UniversityViewModel
    typealias ResponseType = UniversityModel
    static var searchTitle: String = "Поиск по ВУЗам"
    func configureCell(
        tableView: UITableView,
        indexPath: IndexPath,
        viewMmodel: UniversityViewModel,
        isSeparatorHidden: Bool = false
    ) -> UITableViewCell {
        let identifier = UniversityTableViewCell.identifier
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath
        ) as? UniversityTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewMmodel)
        cell.hideSeparator(isSeparatorHidden)
        return cell
    }
    
    func titleForItem(
        _ model: UniversityModel
    ) -> String {
        return model.name
    }
    
    func modelToViewModel(
        _ model: [UniversityModel]
    ) -> [UniversityViewModel] {
        model.map { $0.toViewModel() }
    }
    
    func build(
        with model: UniversityModel
    ) -> (UIViewController?, PresentMethod?) {
        (UniversityAssembly.build(for: model), .push)
    }
    
    func endpoint() -> String {
        "/universities"
    }
    
    func queryItems(
        for query: String
    ) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "search", value: query.trim()))
        return queryItems
    }
    
    func registerCells(
        in tableView: UITableView
    ) {
        tableView.register(
            UniversityTableViewCell.self,
            forCellReuseIdentifier: UniversityTableViewCell.identifier
        )
    }
    
    func responseTypeToModel(_ response: [UniversityModel]) -> [UniversityModel] {
        response
    }
}
