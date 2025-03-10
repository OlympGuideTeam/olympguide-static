//
//  SearchStrategy.swift
//  olympguide
//
//  Created by Tom Tim on 02.03.2025.
//

import UIKit

enum PresentMethod {
    case present
    case push
}

protocol SearchStrategy {
    init()
    
    associatedtype ModelType
    associatedtype ViewModelType
    associatedtype ResponseType: Decodable
    
    static var searchTitle: String { get }
    
    func endpoint() -> String
    func queryItems(for query: String) -> [URLQueryItem]
    
    func registerCells(in tableView: UITableView)
    
    func configureCell(
        tableView: UITableView,
        indexPath: IndexPath,
        viewMmodel: ViewModelType,
        isSeparatorHidden: Bool
    ) -> UITableViewCell
    
    func titleForItem(_ model: ModelType) -> String
    func responseTypeToModel(_ response: [ResponseType]) -> [ModelType]
    
    func modelToViewModel(_ model: [ModelType]) -> [ViewModelType]
    func build(with model: ModelType) -> (UIViewController?, PresentMethod?)
}
