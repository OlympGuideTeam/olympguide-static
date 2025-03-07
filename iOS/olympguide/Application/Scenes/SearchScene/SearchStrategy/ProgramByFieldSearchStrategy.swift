//
//  ProgramByFieldSearchStrategy.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

import UIKit

final class ProgramByFieldSearchStrategy : SearchStrategy {
    typealias ModelType = ProgramsByUniversityModel
    typealias ViewModelType = ProgramViewModel
    typealias ResponseType = ProgramsByUniversityModel
    
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
            ProgramTableViewCell.self,
            forCellReuseIdentifier: ProgramTableViewCell.identifier
        )
    }
    
    func configureCell(
        tableView: UITableView,
        indexPath: IndexPath,
        viewMmodel: ProgramViewModel,
        isSeparatorHidden: Bool
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProgramTableViewCell.identifier
        ) as? ProgramTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewMmodel)
        cell.hideSeparator(isSeparatorHidden)
        return cell
    }
    
    func titleForItem(_ model: ProgramsByUniversityModel) -> String {
        model.univer.name
    }
    
    func responseTypeToModel(_ response: [ProgramsByUniversityModel]) -> [ProgramsByUniversityModel] {
        response
    }
    
    static func modelToViewModel(_ model: [ProgramsByUniversityModel]) -> [ProgramViewModel] {
        model.flatMap { $0.toViewModel().programs }
    }
    
    static func build(with model: ProgramsByUniversityModel) -> UIViewController {
        UIViewController()
    }
}
