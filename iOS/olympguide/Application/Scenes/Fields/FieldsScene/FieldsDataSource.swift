//
//  FieldsDataSource.swift
//  olympguide
//
//  Created by Tom Tim on 12.03.2025.
//

import UIKit

enum FieldItem {
    case header(GroupOfFieldsViewModel)
    case field(FieldViewModel, IndexPath)
}

final class FieldsDataSource : NSObject {
    weak var viewController: FieldsViewController?
    
    var routeToField: ((IndexPath) -> Void)?
    
    var fieldItems: [FieldItem] {
        guard let fields = viewController?.fields else {
            return []
        }
        var result: [FieldItem] = []
        for (groupIndex, group) in fields.enumerated() {
            result.append(.header(group))
            if group.isExpanded {
                for (fieldIndex, subField) in group.fields.enumerated() {
                    autoreleasepool {
                        let indexPath = IndexPath(row: fieldIndex, section: groupIndex)
                        result.append(.field(subField, indexPath))
                    }
                }
            }
        }
        return result
    }
    
    
}

// MARK: - UITableViewDataSource
extension FieldsDataSource : UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return fieldItems.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let item = fieldItems[indexPath.row]
        
        switch item {
        case .header(let group):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: UIFieldHeaderCell.identifier,
                for: indexPath
            ) as? UIFieldHeaderCell
            else {
                return UITableViewCell()
            }
            
            cell.configure(
                with: group.mainField,
                isExpanded: group.isExpanded
            )
            
            return cell
        case .field(let field, _):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FieldTableViewCell.identifier,
                for: indexPath
            ) as? FieldTableViewCell
            else {
                return UITableViewCell()
            }
            
            cell.configure(with: field)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension FieldsDataSource : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let item = fieldItems[indexPath.row]
        
        switch item {
        case .header(let group):
            toggleSection(at: indexPath, group: group, in: tableView)
        case .field(_, let realIndexPath):
            tableView.deselectRow(at: indexPath, animated: true)
            routeToField?(realIndexPath)
        }
    }
    
    func toggleSection(
        at indexPath: IndexPath,
        group: GroupOfFieldsViewModel,
        in tableView: UITableView
    ) {
        let toggleIndex = indexPath.row
        let fieldsCount = group.fields.count
        
        tableView.beginUpdates()
        
        if group.isExpanded {
            group.isExpanded = false
            var indexPathsToDelete: [IndexPath] = []
            
            for i in 1...fieldsCount {
                indexPathsToDelete.append(IndexPath(row: toggleIndex + i, section: 0))
            }
            
            tableView.deleteRows(at: indexPathsToDelete, with: .fade)
        }
        else {
            group.isExpanded = true

            var indexPathsToInsert: [IndexPath] = []
            for i in 1...fieldsCount {
                indexPathsToInsert.append(IndexPath(row: toggleIndex + i, section: 0))
            }
            tableView.insertRows(at: indexPathsToInsert, with: .fade)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
