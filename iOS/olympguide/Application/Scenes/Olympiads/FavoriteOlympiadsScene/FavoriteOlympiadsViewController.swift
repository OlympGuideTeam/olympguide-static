//
//  FavoriteOlympiadsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit
import Combine

// MARK: - Constants
fileprivate enum Constants {
    enum Colors {
        static let refreshTint = UIColor.systemCyan
        static let searchButtonTint = UIColor.black
        static let tableViewBackground = UIColor.white
        static let titleLabelTextColor = UIColor.black
    }
    
    enum Fonts {
    }
    
    enum Dimensions {
        static let tableViewTopMargin: CGFloat = 13
    }
    
    enum Strings {
        static let olympiadsTitle = "Избранные олимпиады"
        static let backButtonTitle = "Избранные"
    }
}

final class FavoriteOlympiadsViewController : UIViewController {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
    // MARK: - VIP
    var interactor: (OlympiadsDataStore & OlympiadsBusinessLogic)?
    var router: OlympiadsRoutingLogic?
    
    // MARK: - Variables
    private let tableView: UICustomTbleView = UICustomTbleView()
    var dataSource: FavoriteOlympiadsDataSource = FavoriteOlympiadsDataSource()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    var olympiads: [OlympiadViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureRefreshControl()
        setupDataSource()
        configureTableView()
        
        interactor?.loadOlympiads(
            with: Olympiads.Load.Request(
                params: Dictionary<ParamType,
                SingleOrMultipleArray<Param>>()
            )
        )
        
        let backItem = UIBarButtonItem(
            title: Constants.Strings.backButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backItem
    }
    
    private func configureNavigationBar() {
        navigationItem.title = Constants.Strings.olympiadsTitle
        
        if let navigationController = self.navigationController as? NavigationBarViewController {
            navigationController.searchButtonPressed = { [weak self] sender in
                guard sender.alpha == 1 else { return }
                self?.router?.routeToSearch()
            }
        }
    }
    
    func configureRefreshControl() {
        refreshControl.tintColor = Constants.Colors.refreshTint
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    // MARK: - Private funcs
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        
        tableView.register(
            OlympiadTableViewCell.self,
            forCellReuseIdentifier: OlympiadTableViewCell.identifier
        )
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        tableView.refreshControl = refreshControl
    }
    
    func getEmptyLabel() -> UILabel? {
        if !olympiads.isEmpty { return nil }
        let emptyLabel = UILabel(frame: self.tableView.bounds)
        emptyLabel.text = "Избранных олимпиад пока нет"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .black
        emptyLabel.font = FontManager.shared.font(for: .emptyTableLabel)
        return emptyLabel
    }
    
    @objc
    private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.interactor?.loadOlympiads(
                with: Olympiads.Load.Request(
                    params: Dictionary<ParamType, SingleOrMultipleArray<Param>>()
                )
            )
            self.refreshControl.endRefreshing()
        }
    }
}

extension FavoriteOlympiadsViewController {
    func setupDataSource() {
        dataSource.viewController = self
        
        dataSource.onOlympiadSelect = { [weak self] index in
            self?.router?.routeToOlympiad(with: index)
        }
        
        dataSource.onFavoriteOlympiadTapped = { [weak self] olympiadId, isFavorite in
            if !isFavorite {
                self?.favoritesManager.removeOlympiadFromFavorites(olympiadId: olympiadId)
            }
        }
    }

}

extension FavoriteOlympiadsViewController : OlympiadsDisplayLogic {
    func displaySetFavorite(at index: Int, _: Bool) {
        olympiads.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        tableView.backgroundView = self.getEmptyLabel()
        if index == olympiads.count && index != 0 {
            let indexPath = IndexPath(row: index - 1, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? OlympiadTableViewCell {
                cell.hideSeparator(true)
            }
        }
    }
    
    func displayOlympiads(with viewModel: Olympiads.Load.ViewModel) {
        olympiads = viewModel.olympiads
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            tableView.backgroundView = getEmptyLabel()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}
