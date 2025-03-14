//
//  OlympiadsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

import UIKit
import Combine

protocol WithSearchButton { }

// MARK: - Constants
fileprivate enum Constants {
    enum Colors {
        static let refreshTint = UIColor.systemCyan
        static let searchButtonTint = UIColor.black
        static let tableViewBackground = UIColor.white
        static let titleLabelTextColor = UIColor.black
    }
    
    
    enum Dimensions {
        static let tableViewTopMargin: CGFloat = 13
    }
    
    enum Strings {
        static let olympiadsTitle = "Олимпиады"
        static let backButtonTitle = "Олимпиады"
    }
    
    enum Images {
        static let searchIcon: String =  "magnifyingglass"
    }
}

final class OlympiadsViewController: UIViewController, WithSearchButton {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    // MARK: - VIP
    var interactor: (OlympiadsDataStore & OlympiadsBusinessLogic)?
    var router: OlympiadsRoutingLogic?
    
    var filterItems: [FilterItem] = []
    private var selectedParams: [ParamType: SingleOrMultipleArray<Param>] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Variables
    private let tableView = UICustomTbleView()
    private let dataSource = OlympiadsDataSource()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    lazy var filterSortView: FilterSortView = FilterSortView()
    
    var olympiads: [OlympiadViewModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterItems()
        setupDataSource()
        
        configureUI()
        
        loadOlympiads()
        
        setupAuthBindings()
    }
    
    private func loadOlympiads() {
        let request = Olympiads.Load.Request(params: selectedParams)
        interactor?.loadOlympiads(with: request)
    }
    
    private func setupFilterItems() {
        let sortItem = FilterItem(
            paramType: .sort,
            title: "Сортировать",
            initMethod: .models([
                OptionViewModel(id: 1, name: "По уровню"),
                OptionViewModel(id: 2, name: "По профилю"),
                OptionViewModel(id: 3, name: "По имени")
            ]),
            isMultipleChoice: false
        )
        
        let levelFilterItem = FilterItem(
            paramType: .olympiadLevel,
            title: "Уровень",
            initMethod: .models([
                OptionViewModel(id: 1, name: "I уровень"),
                OptionViewModel(id: 2, name: "II уровень"),
                OptionViewModel(id: 3, name: "III уровень")
            ]),
            isMultipleChoice: true
        )
        
        let profileFilterItem = FilterItem(
            paramType: .olympiadProfile,
            title: "Профиль",
            initMethod: .endpoint("/meta/olympiad-profiles"),
            isMultipleChoice: true
        )
        
        filterItems = [
            sortItem,
            levelFilterItem,
            profileFilterItem
        ]
        
        for item in filterItems {
            selectedParams[item.paramType] = SingleOrMultipleArray<Param>(isMultiple: item.isMultipleChoice)
        }
    }
}

// MARK: - UI Configuration
extension OlympiadsViewController {
    private func configureUI() {
        configureNavigationBar()
        setupFilterSortView()
        configureRefreshControl()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = Constants.Strings.olympiadsTitle
        
        let backItem = UIBarButtonItem(
            title: Constants.Strings.backButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backItem
        
        if let navigationController = self.navigationController as? NavigationBarViewController {
            navigationController.searchButtonPressed = { [weak self] sender in
                guard sender.alpha == 1 else { return }
                self?.router?.routeToSearch()
            }
        }
    }
    
    private func configureRefreshControl() {
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
        
        let headerContainer = UIView()
        headerContainer.backgroundColor = .white
        
        headerContainer.addSubview(filterSortView)
        
        filterSortView.pinTop(to: headerContainer.topAnchor, Constants.Dimensions.tableViewTopMargin)
        filterSortView.pinLeft(to: headerContainer.leadingAnchor)
        filterSortView.pinRight(to: headerContainer.trailingAnchor)
        filterSortView.pinBottom(to: headerContainer.bottomAnchor, 10)
        
        tableView.addHeaderView(headerContainer)
    }
    
    @objc
    private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            [weak self] in
            self?.loadOlympiads()
            self?.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension OlympiadsViewController {
    private func setupDataSource() {
        dataSource.viewController = self
        dataSource.onOlympiadSelect = { [weak self] index in
            self?.router?.routeToOlympiad(with: index)
        }
        
        dataSource.onFavoriteProgramTapped = { [weak self] index, isFavorite in
            self?.favoriteProgramTapped(index, isFavorite)
        }
    }
    
    private func favoriteProgramTapped(_ index: Int, _ isFavorite: Bool) {
        if isFavorite {
            olympiads[index].like = true
            guard
                let model = interactor?.olympiadModel(at: index)
            else { return }
            
            favoritesManager.addOlympiadToFavorites(model: model)
        } else {
            olympiads[index].like = false
            favoritesManager.removeOlympiadFromFavorites(olympiadId: olympiads[index].olympiadId)
        }
    }
}

// MARK: - OlympiadsDisplayLogic
extension OlympiadsViewController : OlympiadsDisplayLogic {
    func displayOlympiads(with viewModel: Olympiads.Load.ViewModel) {
        olympiads = viewModel.olympiads
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func displaySetFavorite(at index: Int, _ isFavorite: Bool) {
        if self.olympiads[index].like == isFavorite { return }
        self.olympiads[index].like = isFavorite
        self.tableView.reloadRows(
            at: [IndexPath(row: index, section: 0)],
            with: .automatic
        )
    }
}

// MARK: - OptionsViewControllerDelegate
extension OlympiadsViewController : OptionsViewControllerDelegate {
    func didSelectOption(
        _ indices: Set<Int>,
        _ optionsNames: [OptionViewModel],
        paramType: ParamType?
    ) {
        guard let paramType = paramType else { return }
        guard let index = filterItems.firstIndex(where: { $0.paramType == paramType }) else { return }
        
        filterItems[index].selectedIndices = indices
        
        filterItems[index].selectedParams.clear()
        for option in optionsNames {
            if let param = Param(paramType: paramType, option: option) {
                filterItems[index].selectedParams.add(param)
            }
        }
        
        selectedParams[paramType]?.clear()
        for param in filterItems[index].selectedParams.array {
            selectedParams[paramType]?.add(param)
        }
        
        loadOlympiads()
    }
}

// MARK: - Filterble
extension OlympiadsViewController: Filterble {
    func deleteFilter(forItemAt index: Int) {
        let item = filterItems[index]
        selectedParams[item.paramType]?.clear()
        
        loadOlympiads()
    }
}

// MARK: - Combine
extension OlympiadsViewController {
    private func setupAuthBindings() {
        authManager.isAuthenticatedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuth in
                if isAuth {
                    self?.loadOlympiads()
                }
            }.store(in: &cancellables)
    }
}
