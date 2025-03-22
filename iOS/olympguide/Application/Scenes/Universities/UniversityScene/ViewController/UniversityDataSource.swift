//
//  UniversityProgramsDataSource.swift
//  olympguide
//
//  Created by Tom Tim on 11.03.2025.
//

import UIKit

enum ProgramByFieldItem {
    case header(GroupOfProgramsViewModel)
    case cell(ProgramViewModel, IndexPath)
}

final class UniversityDataSource: NSObject {
    @InjectSingleton
    var authManager: AuthManagerProtocol
    weak var viewController: UniversityViewController?
    
    var onProgramSelect: ((IndexPath) -> Void)?
    var onFavoriteProgramTapped: ((IndexPath, Bool) -> Void)?
    var isShimmering: Bool = true
    
    var programItems: [ProgramByFieldItem] {
        guard let groups = viewController?.groupsOfProgramsViewModel else {
            return []
        }
        var result: [ProgramByFieldItem] = []
        for (groupIndex, group) in groups.enumerated() {
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
    
    func register(in tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(
            ProgramTableViewCell.self,
            forCellReuseIdentifier: ProgramTableViewCell.identifier
        )
        tableView.register(
            UIFieldHeaderCell.self,
            forCellReuseIdentifier: UIFieldHeaderCell.identifier
        )
    }
}

// MARK: - UITableViewDataSource
extension UniversityDataSource: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        isShimmering ? 6 : programItems.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        if isShimmering {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ShimmerCell.identifier,
                for: indexPath
            ) as? ShimmerCell
            else {
                return UITableViewCell()
            }
            cell.startShimmering()
            return cell
        }
        
        let item = programItems[indexPath.row]
        
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
                with: group.field,
                isExpanded: group.isExpanded
            )
            
            return cell
        case .cell(let program, let realIndexPath):
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ProgramTableViewCell.identifier,
                    for: indexPath
                ) as? ProgramTableViewCell
            else {
                return UITableViewCell()
            }
            
            cell.configure(with: program)
            cell.hideSeparator(isSeparatorHidden(indexPath))
            cell.favoriteButtonTapped = { [weak self] _, isFavorite in
                self?.onFavoriteProgramTapped?(realIndexPath, isFavorite)
            }
            
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

// MARK: - UITableViewDelegate
extension UniversityDataSource : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            onProgramSelect?(realIndexPath)
        }
    }
    
    
    func toggleSection(
        at indexPath: IndexPath,
        group: GroupOfProgramsViewModel,
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
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard
            let interactor = viewController?.interactor,
            let university = interactor.university,
            case .cell(let programViewModel, let realIndexPath) = programItems[indexPath.row]
        else { return nil }
        
        let program = interactor.program(at: realIndexPath)

        return UIContextMenuConfiguration(
            identifier: realIndexPath as NSCopying,
            previewProvider: {
                let detailVC = ProgramAssembly.build(for: program, by: university)
                return detailVC
            },
            actionProvider: { _ in
                guard self.authManager.isAuthenticated else { return nil }
                let image = programViewModel.like ?
                AllConstants.Common.Images.unlike :
                AllConstants.Common.Images.like
                
                let title = programViewModel.like ?
                "Убрать из избранного" :
                "Добавить в избранное"
                
                let favoriteAction = UIAction(
                    title: title,
                    image: image,
                    handler: { _ in
                        self.onFavoriteProgramTapped?(realIndexPath, !programViewModel.like)
                        guard let cell = tableView.cellForRow(at: indexPath) as? ProgramTableViewCell else { return }
                        cell.favoriteButton.setImage(image, for: .normal)
                    }
                )
                return UIMenu(title: "", children: [favoriteAction])
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
            onProgramSelect?(indexPath)
        }
    }
}
