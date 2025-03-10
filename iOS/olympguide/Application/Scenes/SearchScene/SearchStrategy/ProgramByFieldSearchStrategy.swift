//
//  ProgramByFieldSearchStrategy.swift
//  olympguide
//
//  Created by Tom Tim on 06.03.2025.
//

import UIKit

final class ProgramByFieldSearchStrategy : SearchStrategy {
    typealias ModelType = ProgramShortModel
    typealias ViewModelType = ProgramViewModel
    typealias ResponseType = ProgramsByUniversityModel
    
    var response: [ResponseType]?
    
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
    
    func titleForItem(_ model: ProgramShortModel) -> String {
        model.name
    }
    
    func responseTypeToModel(_ response: [ProgramsByUniversityModel]) -> [ProgramShortModel] {
        self.response = response
        return response.flatMap { $0.programs }
    }
    
    func modelToViewModel(_ model: [ProgramShortModel]) -> [ProgramViewModel] {
        model.map { $0.toViewModel() }
    }
    
    func build(with model: ProgramShortModel) -> (UIViewController?, PresentMethod?) {
        guard let response = self.response else {
            return (nil, nil)
        }
        for university in response {
            if university.programs.firstIndex(of: model) != nil {
                let programVC = ProgramAssembly.build(
                    for: model,
                    by: university.univer
                )
                return (programVC, .push)
            }
        }
        return (nil, nil)
    }
}
