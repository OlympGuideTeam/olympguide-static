//
//  OlympiadSearchStrategy.swift
//  olympguide
//
//  Created by Tom Tim on 02.03.2025.
//

import UIKit

// MARK: - Олимпиады
struct OlympiadSearchStrategy: SearchStrategy {
    typealias ModelType = OlympiadModel
    typealias ViewModelType = OlympiadViewModel
    typealias ResponseType = OlympiadModel
    
    func endpoint() -> String {
        "/olympiads"
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
        viewMmodel: OlympiadViewModel,
        isSeparatorHidden: Bool
    ) -> UITableViewCell {
        let identifier = OlympiadTableViewCell.identifier
        let cell = tableView.dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath
        ) as? OlympiadTableViewCell
            ?? OlympiadTableViewCell(style: .default, reuseIdentifier: identifier)
        
        cell.configure(with: viewMmodel)
        cell.hideSeparator(isSeparatorHidden)
        return cell
    }
    
    func titleForItem(_ model: OlympiadModel) -> String {
        return model.name
    }
    
    static func modelToViewModel(_ model: OlympiadModel) -> OlympiadViewModel {
        OlympiadViewModel(
            name: model.name,
            profile: model.profile,
            level: String(repeating: "I", count: model.level)
        )
    }
    
    static func build(with model: ModelType) -> UIViewController {
        OlympiadAssembly.build(with: model)
    }
    
    func responseTypeToModel(_ response: [OlympiadModel]) -> [OlympiadModel] {
        response
    }
}
