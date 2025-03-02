//
//  OlympiadsRouter.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

import UIKit

final class OlympiadsRouter: OlympiadsRoutingLogic, OlympiadsDataPassing {
    weak var viewController: UIViewController?
    var dataStore: OlympiadsDataStore?
    
    func routeToSearch() {
        let searchVC = SearchViewController(searchType: .olympiads)
        searchVC.modalPresentationStyle = .overFullScreen
        viewController?.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func routeToOlympiad(with index: Int) {
        guard let olympiad = dataStore?.olympiads[index] else { return }
        let olympiadVC = OlympiadAssembly.build(with: olympiad)
        viewController?.navigationController?.pushViewController(olympiadVC, animated: true)
    }
}
