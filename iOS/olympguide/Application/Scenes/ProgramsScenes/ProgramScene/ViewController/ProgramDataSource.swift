//
//  ProgramDataSource.swift
//  olympguide
//
//  Created by Tom Tim on 12.03.2025.
//

import UIKit

final class ProgramDataSource : NSObject {
    var onBenefitSelect: ((Int) -> Void)?
    
    weak var viewController: ProgramViewController?
    var isShimmering: Bool = true
    
    func register(in tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(
            OlympiadTableViewCell.self,
            forCellReuseIdentifier: OlympiadTableViewCell.identifier
        )
    }
}

extension ProgramDataSource : UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let benefits = viewController?.benefits else { return 0 }
        return isShimmering ? 6 : benefits.count
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
                withIdentifier: OlympiadTableViewCell.identifier,
                for: indexPath
            ) as? OlympiadTableViewCell,
            let benefits = viewController?.benefits
        else {
            return UITableViewCell()
        }
        
        let benefitModel = benefits[indexPath.row]
        cell.isFavoriteButtonHidden = true
        cell.configure(with: benefitModel)
        cell.hideSeparator(indexPath.row == benefits.count - 1)
        
        return cell
    }
}

extension ProgramDataSource : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        onBenefitSelect?(indexPath.row)
    }
    
    func tableView(
      _ tableView: UITableView,
      contextMenuConfigurationForRowAt indexPath: IndexPath,
      point: CGPoint
    ) -> UIContextMenuConfiguration? {
        guard let benefits = viewController?.benefits else { return nil }
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                let detailVC = BenefitViewController(with: benefits[indexPath.row])
                return detailVC
            },
            actionProvider: { _ in
                return UIMenu(title: "", children: [
                ])
            }
        )
    }
}
