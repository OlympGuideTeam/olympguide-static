//
//  UniversitiesDataSource.swift
//  olympguide
//
//  Created by Tom Tim on 12.03.2025.
//

import UIKit

final class UniversitiesDataSource : NSObject {
    weak var viewController: UniversitiesViewController?
    
    var onUniversitySelect: ((Int) -> Void)?
    var onFavoriteUniversityTapped: ((IndexPath, Bool) -> Void)?
    
    var isShimmering: Bool = true
    
    func register(in tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            UniversityTableViewCell.self,
            forCellReuseIdentifier: UniversityTableViewCell.identifier
        )
    }
}

extension UniversitiesDataSource : UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if isShimmering { return 6 }
        guard let universities = viewController?.universities else { return 0}
        return universities.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if isShimmering {
            return getShimmerCell(tableView, cellForRowAt: indexPath)
        }
        
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: UniversityTableViewCell.identifier,
                for: indexPath
            ) as? UniversityTableViewCell,
            let universities = viewController?.universities
        else {
            fatalError("Could not dequeue cell")
        }
        
        let universityViewModel = universities[indexPath.row]
        cell.configure(with: universityViewModel)
        
        cell.favoriteButtonTapped = { [weak self] _, isFavorite in
            self?.onFavoriteUniversityTapped?(indexPath, isFavorite)
        }
        
        cell.hideSeparator(indexPath.row == universities.count - 1)
        
        return cell
    }
}


extension UniversitiesDataSource : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        onUniversitySelect?(indexPath.row)
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let interactor = viewController?.interactor else { return nil }
        let university = interactor.universityModel(at: indexPath.row)

        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                let detailVC = UniversityAssembly.build(for: university)
                return detailVC
            },
            actionProvider: { _ in
                let favoriteAction = UIAction(
                    title: "Добавить в избранное",
                    image: UIImage(systemName: "star.fill"),
                    handler: { _ in
                        self.onFavoriteUniversityTapped?(indexPath, true)
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
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        onUniversitySelect?(indexPath.row)
    }
}
