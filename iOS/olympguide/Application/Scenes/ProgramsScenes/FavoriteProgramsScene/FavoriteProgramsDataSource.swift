//
//  FavoriteProgramsDataSource.swift
//  olympguide
//
//  Created by Tom Tim on 12.03.2025.
//

import UIKit

final class FavoriteProgramsDataSource : NSObject {
    weak var viewController: FavoriteProgramsViewController?
    
    var onProgramSelect: ((IndexPath) -> Void)?
    var onSectionToggle: ((Int) -> Void)?
    var onFavoriteProgramTapped: ((Int, Bool) -> Void)?
}

// MARK: - UITableViewDataSource
extension FavoriteProgramsDataSource : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let programs = viewController?.programs else { return 0 }
        return programs.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let programs = viewController?.programs else { return 0 }
        return programs[section].isExpanded ? programs[section].programs.count : 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ProgramTableViewCell.identifier
            ) as? ProgramTableViewCell,
            let programs = viewController?.programs
        else { return UITableViewCell() }
        
        cell.configure(with: programs[indexPath.section].programs[indexPath.row])
        
        cell.favoriteButtonTapped = { [weak self] sender, isFavorite in
            self?.onFavoriteProgramTapped?(sender.tag, isFavorite)
        }
        
        cell.hideSeparator(indexPath.row == programs[indexPath.section].programs.count - 1)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteProgramsDataSource : UITableViewDelegate{
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        onProgramSelect?(indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard
            let header = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: UIUniversityHeader.identifier
            ) as? UIUniversityHeader,
            let programs = viewController?.programs
        else { return nil }
        
        header.configure(
            with: programs[section].university,
            isExpanded: programs[section].isExpanded
        )
        header.toggleSection = { [weak self] section in
            self?.onSectionToggle?(section)
        }
        return header
    }
}
