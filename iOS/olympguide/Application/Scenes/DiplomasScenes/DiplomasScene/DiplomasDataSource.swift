//
//  DiplomasDataSource.swift
//  olympguide
//
//  Created by Tom Tim on 24.03.2025.
//

import UIKit

final class DiplomasDataSource : NSObject {
    weak var viewController: DiplomasViewController?
    var deleteDiplomaAt: ((IndexPath) -> Void)?
    var diplomas: [DiplomaViewModel] {
        guard let diplomas = viewController?.diplomas else {
            return []
        }
        return diplomas
    }
    
    func register(in tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            OlympiadTableViewCell.self,
            forCellReuseIdentifier: OlympiadTableViewCell.identifier
        )
    }
}

extension DiplomasDataSource: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return diplomas.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: OlympiadTableViewCell.identifier,
                for: indexPath
            ) as? OlympiadTableViewCell
        else { return UITableViewCell() }
        
        cell.configure(with: diplomas[indexPath.row])
        cell.hideSeparator(indexPath.row == diplomas.count - 1)
        return cell
    }
}

extension DiplomasDataSource : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewController?.router?.routeToDiploma(at: indexPath.row)
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") {
            [weak self] _, _, completionHandler in
            self?.deleteDiplomaAt?(indexPath)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        deleteAction.backgroundColor = .red

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
//    func tableView(
//        _ tableView: UITableView,
//        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
//    ) -> UISwipeActionsConfiguration? {
//        let editAction = UIContextualAction(style: .destructive, title: "Изменить") {
//            [weak self] _, _, completionHandler in
//            self?.deleteDiplomaAt?(indexPath)
//            completionHandler(true)
//        }
//        editAction.image = UIImage(systemName: "pencil.and.scribble")?
//            .withTintColor(.white, renderingMode: .alwaysOriginal)
////        editAction.backgroundColor = AllConstants.Common.Colors.accient
//        editAction.backgroundColor = UIColor(hex: "#74F39F")
//        
//        return UISwipeActionsConfiguration(actions: [editAction])
//    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: nil
        ) { _ in
            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(systemName: "trash.fill"),
                attributes: .destructive
            ) { [weak self] _ in
                self?.deleteDiplomaAt?(indexPath)
            }
            
//            let editAction = UIAction(
//                title: "Редактировать",
//                image: UIImage(systemName: "pencil.and.scribble")
//            ) { _ in
//                
//            }
            
            return UIMenu(title: "", children: [deleteAction])
        }
    }

    func tableView(
        _ tableView: UITableView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = tableView.cellForRow(at: indexPath) else {
            return nil
        }
        return UITargetedPreview(view: cell)
    }

    func tableView(
        _ tableView: UITableView,
        previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = tableView.cellForRow(at: indexPath) else {
            return nil
        }
        return UITargetedPreview(view: cell)
    }
}
