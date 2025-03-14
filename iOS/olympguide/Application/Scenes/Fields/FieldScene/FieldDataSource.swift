//
//  FieldDataSource.swift
//  olympguide
//
//  Created by Tom Tim on 13.03.2025.
//

import UIKit

enum ProgramByUniItem {
    case header(ProgramsByUniversityViewModel)
    case cell(ProgramViewModel, IndexPath)
}

final class FieldDataSource : NSObject {
    weak var viewController: FieldViewController?
    
    var routeToProgram: ((IndexPath) -> Void)?
    var onFavoriteProgramTapped: ((IndexPath, Bool) -> Void)?
    
    var programItems: [ProgramByUniItem] {
        guard let groupsOfPrograms = viewController?.programs else { return [] }
        var result: [ProgramByUniItem] = []
        for (groupIndex, group) in groupsOfPrograms.enumerated() {
            result.append(.header(group))
            guard group.isExpanded else { continue }
            for (programIndex, program) in group.programs.enumerated() {
                autoreleasepool {
                    let indexPath = IndexPath(row: programIndex, section: groupIndex)
                    result.append(.cell(program, indexPath))
                }
            }
        }
        
        return result
    }
}

extension FieldDataSource : UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return programItems.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let item = programItems[indexPath.row]
        
        switch item {
        case .header(let group):
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: UIUniversityHeaderCell.identifier,
                    for: indexPath
                ) as? UIUniversityHeaderCell
            else { return UITableViewCell() }
            
            cell.configure(
                with: group.university,
                isExpanded: group.isExpanded
            )
            
            return cell
            
        case .cell(let program, let realIndexPath):
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ProgramTableViewCell.identifier,
                    for: indexPath
                ) as? ProgramTableViewCell
            else { return UITableViewCell() }
            
            cell.configure(with: program)
            cell.favoriteButtonTapped = { [weak self]  _, isFavorite in
                self?.onFavoriteProgramTapped?(realIndexPath, isFavorite)
            }
            
            cell.hideSeparator(isSeparatorHidden(indexPath))
            return cell
        }
    }
    
    func isSeparatorHidden(_ indexPath: IndexPath) -> Bool {
        guard indexPath.row < programItems.count - 1 else { return true }

        if case .header = programItems[indexPath.row + 1] {
            return true
        }

        return false
    }
}

extension FieldDataSource : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let item = programItems[indexPath.row]
        
        switch item {
        case .header(let group):
            toggleSection(
                at: indexPath,
                group: group,
                in: tableView
            )
        case .cell(_, let realIndexPath):
            tableView.deselectRow(at: indexPath, animated: true)
            routeToProgram?(realIndexPath)
        }
    }
    
    func toggleSection(
        at indexPath: IndexPath,
        group: ProgramsByUniversityViewModel,
        in tableView: UITableView
    ) {
        let toggleIndex = indexPath.row
        let programsCount = group.programs.count
        
        tableView.beginUpdates()
        
        if group.isExpanded {
            group.isExpanded = false
            var indexPathsToDelete: [IndexPath] = []
            
            for i in 1...programsCount {
                indexPathsToDelete.append(IndexPath(row: toggleIndex + i, section: 0))
            }
            
            tableView.deleteRows(at: indexPathsToDelete, with: .fade)
        }
        else {
            group.isExpanded = true

            var indexPathsToInsert: [IndexPath] = []
            for i in 1...programsCount {
                indexPathsToInsert.append(IndexPath(row: toggleIndex + i, section: 0))
            }
            tableView.insertRows(at: indexPathsToInsert, with: .fade)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
