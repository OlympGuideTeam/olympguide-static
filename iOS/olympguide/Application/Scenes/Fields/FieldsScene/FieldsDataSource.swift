//
//  FieldsDataSource.swift
//  olympguide
//
//  Created by Tom Tim on 12.03.2025.
//

import UIKit

enum FieldItem {
    case header(GroupOfFieldsViewModel)
    case cell(FieldViewModel, IndexPath)
}

final class FieldsDataSource : NSObject {
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
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
                        result.append(.cell(subField, indexPath))
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
        case .cell(let field, _):
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
        case .cell(_, let realIndexPath):
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
    
    func tableView(
            _ tableView: UITableView,
            contextMenuConfigurationForRowAt indexPath: IndexPath,
            point: CGPoint
        ) -> UIContextMenuConfiguration? {
            guard
                let interactor = viewController?.interactor,
//                let university = interactor.university,
                case .cell(_, let realIndexPath) = fieldItems[indexPath.row]
            else { return nil }
            let field = interactor.field(at: realIndexPath)

            return UIContextMenuConfiguration(
                identifier: realIndexPath as NSCopying,
                previewProvider: {
                    let detailVC = FieldAssembly.build(for: field)
                    return detailVC
                },
                actionProvider: {_ in
                    return nil
                }
            )
        }

        func tableView(
            _ tableView: UITableView,
            willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
            animator: UIContextMenuInteractionCommitAnimating
        ) {
            animator.addCompletion { [weak self] in
                guard
                    let self = self,
                    let indexPath = configuration.identifier as? IndexPath
                else { return }
                routeToField?(indexPath)
            }
        }
}
