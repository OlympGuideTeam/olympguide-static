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
    // MARK: - VIP
    var interactor: (OlympiadsDataStore & OlympiadsBusinessLogic)?
    var router: OlympiadsRoutingLogic?
    
    var filterItems: [FilterItem] = []
    private var selectedParams: [ParamType: SingleOrMultipleArray<Param>] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Variables
    private let tableView = UITableView()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    lazy var filterSortView: FilterSortView = FilterSortView()
    
    private var olympiads: [OlympiadViewModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterItems()
        configureUI()
        
        loadOlympiads()
        
        setupBindings()
    }
    
    private func loadOlympiads() {
        let request = Olympiads.Load.Request(params: selectedParams)
        interactor?.loadOlympiads(request)
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
    
    func displayError(message: String) {
        print("Error: \(message)")
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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        tableView.register(
            OlympiadTableViewCell.self,
            forCellReuseIdentifier: OlympiadTableViewCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Constants.Colors.tableViewBackground
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        
        let headerContainer = UIView()
        headerContainer.backgroundColor = .white
        
        headerContainer.addSubview(filterSortView)
        
        filterSortView.pinTop(to: headerContainer.topAnchor, Constants.Dimensions.tableViewTopMargin)
        filterSortView.pinLeft(to: headerContainer.leadingAnchor)
        filterSortView.pinRight(to: headerContainer.trailingAnchor)
        filterSortView.pinBottom(to: headerContainer.bottomAnchor, 10)
        
        headerContainer.layoutIfNeeded()
        
        let targetSize = CGSize(
            width: tableView.bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        let height = headerContainer.systemLayoutSizeFitting(targetSize).height
        
        headerContainer.frame = CGRect(
            x: 0,
            y: 0,
            width: tableView.bounds.width,
            height: height
        )
        
        tableView.tableHeaderView = headerContainer
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
extension OlympiadsViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return (olympiads.count != 0) ? olympiads.count : 10
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
        
        if olympiads.count != 0 {
            let olympiadViewModel = olympiads[indexPath.row]
            cell.configure(with: olympiadViewModel)
            cell.favoriteButtonTapped = { [weak self] sender, isFavorite in
                guard let self = self else { return }
                if isFavorite {
                    self.olympiads[indexPath.row].like = true
                    guard
                        let model = self.interactor?.olympiadModel(at: indexPath.row)
                    else { return }
                    
                    FavoritesManager.shared.addOlympiadToFavorites(model: model)
                } else {
                    self.olympiads[indexPath.row].like = false
                    FavoritesManager.shared.removeOlympiadFromFavorites(olympiadId: sender.tag)
                }
            }
        } else {
            cell.configureShimmer()
        }
        
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension OlympiadsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        router?.routeToOlympiad(with: indexPath.row)
    }
}

// MARK: - OlympiadsDisplayLogic
extension OlympiadsViewController : OlympiadsDisplayLogic {
    func displayOlympiads(_ viewModel: Olympiads.Load.ViewModel) {
        olympiads = viewModel.olympiads
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
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
    private func setupBindings() {
        FavoritesManager.shared.olympiadEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(let olympiad):
                    if let index = self.olympiads.firstIndex(where: { $0.olympiadId == olympiad.olympiadID} ) {
                        if self.olympiads[index].like == true { break }
                        self.olympiads[index].like = true
                        self.tableView.reloadRows(
                            at: [IndexPath(row: index, section: 0)],
                            with: .automatic
                        )
                    }
                case .removed(let olympiadId):
                    if let index = self.olympiads.firstIndex(where: { $0.olympiadId == olympiadId} ) {
                        if self.olympiads[index].like == false { break }
                        self.olympiads[index].like = false
                        self.tableView.reloadRows(
                            at: [IndexPath(row: index, section: 0)],
                            with: .automatic
                        )
                    }
                case .error(let olympiadId):
                    if let index = self.olympiads.firstIndex(where: { $0.olympiadId == olympiadId} ) {
                        if self.olympiads[index].like == interactor?.favoriteStatus(at: index) { break }
                        self.olympiads[index].like = interactor?.favoriteStatus(at: index) ?? false
                    }
                case .access(let olympiadId, let isFavorite):
                    if let index = self.olympiads.firstIndex(where: { $0.olympiadId == olympiadId} ) {
                        interactor?.setFavoriteStatus(at: index, to: isFavorite)
                    }
                }
                
            }.store(in: &cancellables)
    }
}
