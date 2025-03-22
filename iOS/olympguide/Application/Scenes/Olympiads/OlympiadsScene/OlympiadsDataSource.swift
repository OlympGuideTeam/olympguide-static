//
//  OlympiadsDataSource.swift
//  olympguide
//
//  Created by Tom Tim on 12.03.2025.
//

import UIKit

final class OlympiadsDataSource : NSObject, UITableViewDataSource, UITableViewDelegate {
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    weak var viewController: OlympiadsViewController?
    var onFavoriteOlympiadTapped: ((Int, Bool) -> Void)?
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
                self?.onFavoriteOlympiadTapped?(indexPath.row, isFavorite)
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
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard
            let olympiadViewModel = viewController?.olympiads[indexPath.row],
            let interactor = viewController?.interactor
        else { return nil }
        
        let olympiad = interactor.olympiadModel(at: indexPath.row)

        return UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: {
                let detailVC = OlympiadAssembly.build(with: olympiad)
                return detailVC
            },
            actionProvider: { _ in
                guard self.authManager.isAuthenticated else { return nil }
                let image = olympiadViewModel.like ?
                AllConstants.Common.Images.unlike :
                AllConstants.Common.Images.like
                
                let title = olympiadViewModel.like ?
                "Убрать из избранного" :
                "Добавить в избранное"
                
                let favoriteAction = UIAction(
                    title: title,
                    image: image,
                    handler: { _ in
                        self.onFavoriteOlympiadTapped?(indexPath.row, !olympiadViewModel.like)
                        guard let cell = tableView.cellForRow(at: indexPath) as? OlympiadTableViewCell else { return }
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
            onOlympiadSelect?(indexPath.row)
        }
    }
}
