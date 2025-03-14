//
//  NSObject.swift
//  olympguide
//
//  Created by Tom Tim on 14.03.2025.
//

import UIKit

extension NSObject {
    func getShimmerCell(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ShimmerCell.identifier,
                for: indexPath
            ) as? ShimmerCell
        else {
            fatalError("Could not dequeue cell")
        }
        cell.startShimmering()
        return cell
    }
}
