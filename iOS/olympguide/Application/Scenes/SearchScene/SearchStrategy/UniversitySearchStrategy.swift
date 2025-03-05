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
    
    static func modelToViewModel(
        _ model: UniversityModel
    ) -> UniversityViewModel {
        UniversityViewModel(
            universityID: model.universityID,
            name: model.name,
            logoURL: model.logo,
            region: model.region,
            like: model.like ?? false
        )
    }
    
    static func build(
        with model: UniversityModel
    ) -> UIViewController {
        UniversityAssembly.build(for: model)
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
