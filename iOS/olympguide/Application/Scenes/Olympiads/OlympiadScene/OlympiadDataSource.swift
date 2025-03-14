//
//  OlympiadDataSource.swift
//  olympguide
//
//  Created by Tom Tim on 12.03.2025.
//

import UIKit

final class OlympiadDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var viewController: OlympiadViewController?
    
    var onProgramSelect: ((IndexPath) -> Void)?
    var onSectionToggle: ((Int) -> Void)?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let universities = viewController?.universities else {
            return 0
        }
        return universities.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard
            let isExpanded = viewController?.isExpanded,
            let programs = viewController?.programs
        else { return 0 }
        return isExpanded[section] ? programs[section].count : 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: UIProgramWithBenefitsCell.identifier
            ) as? UIProgramWithBenefitsCell,
            let programs = viewController?.programs
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: programs[indexPath.section][indexPath.row], indexPath: indexPath)
        for view in cell.benefitsStack.arrangedSubviews {
            guard let subview = view as? BenefitStackView else { continue }
            subview.createPreviewVC = { indexPath, index in
                let program = programs[indexPath.section][indexPath.row]
                let previewVC = BenefitViewController(with: program, index: index)
                return previewVC
            }
        }
        
        cell.hideSeparator(indexPath.row == programs[indexPath.section].count - 1)
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard
            let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: UIUniversityHeader.identifier
            ) as? UIUniversityHeader,
            let universities = viewController?.universities,
            let isExpanded = viewController?.isExpanded
        else {
            return nil
        }
        
        headerView.configure(
            with: universities[section],
            isExpanded: isExpanded[section]
        )
        
        headerView.tag = section
        
        headerView.toggleSection = { [weak self] section in
            self?.onSectionToggle?(section)
        }
        
        return headerView
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        onProgramSelect?(indexPath)
    }
}
