//
//  ProgramSearchStrategy.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

import UIKit

enum SearchProgramType {
    case inUniversity(id: Int)
}

final class ProgramInUniSearchStrategy : SearchStrategy {
    typealias ModelType = ProgramShortModel
    typealias ViewModelType = ProgramViewModel
    typealias ResponseType = GroupOfProgramsModel
    static var searchTitle: String = "Поиск по программам"
    
    func endpoint() -> String {
        "/university/1/programs/by-field"
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
    
    
    func configureCell(tableView: UITableView, indexPath: IndexPath, viewMmodel: ProgramViewModel, isSeparatorHidden: Bool) -> UITableViewCell {
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
    
    func titleForItem(_ model: ProgramShortModel) -> String {
        return model.name
    }
    
    func responseTypeToModel(
        _ response: [GroupOfProgramsModel]
    ) -> [ProgramShortModel] {
        return response.flatMap { $0.programs }
    }
    
    static func modelToViewModel(_ model: [ProgramShortModel]) -> [ProgramViewModel] {
        model.map { $0.toViewModel() }
    }
    
    static func build(
        with model: ProgramShortModel
    ) -> UIViewController {
        UIViewController()
    }
}
