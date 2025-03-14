//
//  OlympiadsDataSource.swift
//  olympguide
//
//  Created by Tom Tim on 12.03.2025.
//

import UIKit

final class OlympiadsDataSource : NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var viewController: OlympiadsViewController?
    var onFavoriteProgramTapped: ((Int, Bool) -> Void)?
    var onOlympiadSelect: ((Int) -> Void)?
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let olympiads = viewController?.olympiads else { return 0 }
        return olympiads.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: OlympiadTableViewCell.identifier,
                for: indexPath
            ) as? OlympiadTableViewCell,
            let olympiads = viewController?.olympiads
        else {
            return UITableViewCell()
        }
        
            let olympiadViewModel = olympiads[indexPath.row]
            cell.configure(with: olympiadViewModel)
            cell.favoriteButtonTapped = { [weak self] _, isFavorite in
                self?.onFavoriteProgramTapped?(indexPath.row, isFavorite)
            }
            
            cell.hideSeparator(indexPath.row == olympiads.count - 1)
        
        
        return cell
    }

// MARK: - UITableViewDelegate
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        onOlympiadSelect?(indexPath.row)
    }
}
