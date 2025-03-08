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
    
    var sortSelectedIndicies: Set<Int> = []
    var filtersSelectedIndicies: [Set<Int>] = [[], []]
    let sortInit: InitMethod = .models(
        [
            OptionViewModel(id: 1, name: "По уровню"),
            OptionViewModel(id: 2, name: "По профилю"),
            OptionViewModel(id: 3, name: "По имени")
        ]
    )

    let filtersInits: [InitMethod] = [
        .models([
            OptionViewModel(id: 1, name: "I уровень"),
            OptionViewModel(id: 2, name: "II уровень"),
            OptionViewModel(id: 3, name: "III уровень"),
        ]),
        .endpoint(endpoint: "/meta/olympiad-profiles")
    ]
    
    let filtersTypes: [ParamType] = [.olympiadLevel, .olympiadProfile]
    
    private var cancellables = Set<AnyCancellable>()
    
    private var selectedParams: Dictionary<ParamType, SingleOrMultipleArray<Param>> = [
        .sort: SingleOrMultipleArray<Param>(isMultiple: false),
        .olympiadLevel: SingleOrMultipleArray<Param>(isMultiple: true),
        .olympiadProfile: SingleOrMultipleArray<Param>(isMultiple: true),
    ]
    
    // MARK: - Variables
    private let tableView = UITableView()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    private lazy var filterSortView: FilterSortView = FilterSortView()
    
    private var olympiads: [OlympiadViewModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        interactor?.loadOlympiads(
            Olympiads.Load.Request(params: Dictionary<ParamType, SingleOrMultipleArray<Param>>())
        )
        
        setupBindings()
        
        let backItem = UIBarButtonItem(
            title: Constants.Strings.backButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backItem
    }
}

// MARK: - UI Configuration
extension OlympiadsViewController {
    private func configureUI() {
        configureNavigationBar()
        configureFilterSortView()
        configureRefreshControl()
        configureTableView()
    }
    
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
    
    private func configureRefreshControl() {
        refreshControl.tintColor = Constants.Colors.refreshTint
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func configureFilterSortView() {
        filterSortView.configure(
            sortingOption: nil,
            filteringOptions: ["Уровень", "Профиль"]
        )
        
        filterSortView.sortButttonTapped = { [weak self] _ in
            guard let self = self else { return }
            
            var optionsVC: OptionsViewController?
            switch sortInit {
            case .endpoint(let endpoint):
                optionsVC = OptionsViewController(
                    title: "Сортировать",
                    isMultipleChoice: false,
                    selectedIndices: sortSelectedIndicies,
//                    count: 87,
                    endPoint: endpoint
                )
            case .models(let models):
                optionsVC = OptionsViewController(
                    title: "Сортировать",
                    isMultipleChoice: false,
                    selectedIndices: sortSelectedIndicies,
                    options: models
                )
            }
            guard let optionsVC else { return }
            optionsVC.delegate = self
            optionsVC.modalPresentationStyle = .overFullScreen
            present(optionsVC, animated: false)
        }
        
        filterSortView.filterButtonTapped = { [weak self] sender in
            guard let self else { return }
            let initMethod = filtersInits[sender.tag]
            var optionsVC: OptionsViewController?
            switch initMethod {
            case .endpoint(let endpoint):
                optionsVC = OptionsViewController(
                    title: sender.filterTitle,
                    isMultipleChoice: true,
                    selectedIndices: filtersSelectedIndicies[sender.tag],
                    endPoint: endpoint,
                    paramType: filtersTypes[sender.tag]
                )
            case .models(let models):
                optionsVC = OptionsViewController(
                    title: sender.filterTitle,
                    isMultipleChoice: true,
                    selectedIndices: filtersSelectedIndicies[sender.tag],
                    options: models,
                    paramType: filtersTypes[sender.tag]
                )
            }
            guard let optionsVC else { return }
            optionsVC.delegate = self
            optionsVC.modalPresentationStyle = .overFullScreen
            present(optionsVC, animated: false)
        }
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
        
        let targetSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
        let height = headerContainer.systemLayoutSizeFitting(targetSize).height
        
        headerContainer.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: height)
        
        tableView.tableHeaderView = headerContainer
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

// MARK: - FilterSortViewDelegate
extension OlympiadsViewController: FilterSortViewDelegate {
    func filterSortViewDidTapSortButton(_ view: FilterSortView) {
        
    }
    
    func filterSortView(_ view: FilterSortView, didTapFilterWith title: String) {
        
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

extension OlympiadsViewController : OptionsViewControllerDelegate {
    func didSelectOption(
        _ options: Set<Int>,
        _ optionsNames: [OptionViewModel],
        paramType: ParamType?
    ) {
        guard let paramType = paramType else { return }
        selectedParams[paramType]?.clear()
        for option in optionsNames {
            if let param = Param(paramType: paramType, option: option) {
                selectedParams[paramType]?.add(param)
            }
        }
        if paramType == .sort {
            sortSelectedIndicies = options
        } else if paramType == .olympiadLevel {
            filtersSelectedIndicies[0] = options
        } else if paramType == .olympiadProfile {
            filtersSelectedIndicies[1] = options
        }
        
        let request = Olympiads.Load.Request(params: selectedParams)
        interactor?.loadOlympiads(request)
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
