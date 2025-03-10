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
    
    // MARK: - VIP
    var interactor: (OlympiadsDataStore & OlympiadsBusinessLogic & FavoriteOlympiadsBusinessLogic)?
    var router: OlympiadsRoutingLogic?
    
    // MARK: - Variables
    private let tableView = UITableView()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    private var olympiads: [OlympiadViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureRefreshControl()
        configureTableView()
        
        interactor?.loadOlympiads(
            Olympiads.Load.Request(params: Dictionary<ParamType, SingleOrMultipleArray<Param>>())
        )
        
        let backItem = UIBarButtonItem(
            title: Constants.Strings.backButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backItem
        
        setupBindings()
    }
    
    // MARK: - Methods
    func displayError(message: String) {
        print("Error: \(message)")
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        tableView.register(OlympiadTableViewCell.self,
                           forCellReuseIdentifier: OlympiadTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Constants.Colors.tableViewBackground
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
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
                Olympiads.Load.Request(
                    params: Dictionary<ParamType, SingleOrMultipleArray<Param>>()
                )
            )
            self.refreshControl.endRefreshing()
        }
    }
}

extension FavoriteOlympiadsViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return olympiads.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: OlympiadTableViewCell.identifier,
            for: indexPath
        ) as? OlympiadTableViewCell
        else {
            return UITableViewCell()
        }
        
        let olympiadViewModel = olympiads[indexPath.row]
        cell.configure(with: olympiadViewModel)
        cell.favoriteButtonTapped = { sender, isFavorite in
            if !isFavorite {
                FavoritesManager.shared.removeOlympiadFromFavorites(olympiadId: sender.tag)
            }
        }
        cell.hideSeparator(indexPath.row == olympiads.count - 1)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteOlympiadsViewController : UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        router?.routeToOlympiad(with: indexPath.row)
    }
}

extension FavoriteOlympiadsViewController : OlympiadsDisplayLogic {
    func displayOlympiads(_ viewModel: Olympiads.Load.ViewModel) {
        olympiads = viewModel.olympiads
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            tableView.backgroundView = getEmptyLabel()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - Combine
extension FavoriteOlympiadsViewController {
    private func setupBindings() {
        FavoritesManager.shared.olympiadEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(let olympiad):
                    if !self.olympiads.contains(where: { $0.olympiadId == olympiad.olympiadID}) {
                        var viewModel = olympiad.toViewModel()
                        viewModel.like = true
                        
                        let insertIndex = self.olympiads.firstIndex { $0.olympiadId > olympiad.olympiadID } ?? self.olympiads.count
                        
                        self.interactor?.likeOlympiad(olympiad, at: insertIndex)
                        self.olympiads.insert(viewModel, at: insertIndex)
                        
                        let newIndex = IndexPath(row: insertIndex, section: 0)
                        self.tableView.insertRows(at: [newIndex], with: .automatic)
                        self.tableView.backgroundView = nil
                    }
                case .removed(let olympiadId):
                    if let index = self.olympiads.firstIndex(where: { $0.olympiadId == olympiadId }) {
                        self.olympiads.remove(at: index)
                        self.interactor?.dislikeOlympiad(at: index)
                        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        self.tableView.backgroundView = self.getEmptyLabel()
                        if index == self.olympiads.count && index != 0 {
                            let indexPath = IndexPath(row: index - 1, section: 0)
                            if let cell = tableView.cellForRow(at: indexPath) as? OlympiadTableViewCell {
                                cell.hideSeparator(true)
                            }
                        }
                    }
                case .error(let olympiadId):
                    interactor?.handleBatchError(olympiadID: olympiadId)
                case .access(let olympiadId, let isFavorite):
                    interactor?.handleBatchSuccess(olympiadID: olympiadId, isFavorite: isFavorite)
                }
            }
            .store(in: &cancellables)
    }
}
