//
//  UniversitiesViewController.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
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
    
    enum Dimensions {
        static let titleLabelTopMargin: CGFloat = 25
        static let titleLabelLeftMargin: CGFloat = 20
        static let searchButtonSize: CGFloat = 33
        static let searchButtonRightMargin: CGFloat = 20
        static let tableViewTopMargin: CGFloat = 13
    }
    
    enum Strings {
        static let universitiesTitle = "ВУЗы"
        static let backButtonTitle = "ВУЗы"
    }
    
    enum Images {
        static let searchIcon: String =  "magnifyingglass"
    }
}

class UniversitiesViewController: UIViewController, WithSearchButton {
    
    // MARK: - VIP
    var interactor: (UniversitiesDataStore & UniversitiesBusinessLogic)?
    var router: UniversitiesRoutingLogic?
    
    var filterItems: [FilterItem] = []
    var selectedParams: [ParamType: SingleOrMultipleArray<Param>] = [:]
    
    // MARK: - Variables
    private let tableView = UITableView()
    private let titleLabel: UILabel = UILabel()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    lazy var filterSortView: FilterSortView = FilterSortView()
    
    private var universities: [UniversityViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterItems()
        configureNavigationBar()
        configureRefreshControl()
        configureFilterSortView()
        configureTableView()
        setupBindings()
        
        loadUniversities()
    }
    
    func loadUniversities() {
        let request = Universities.Load.Request(params: selectedParams)
        interactor?.loadUniversities(request)
    }
    
    private func setupFilterItems() {
        let regionFilterItem = FilterItem(
            paramType: .region,
            title: "Регион",
            initMethod: .endpoint("/meta/university-regions"),
            isMultipleChoice: true
        )
        
        filterItems = [
            regionFilterItem
        ]
        
        for item in filterItems {
            selectedParams[item.paramType] = SingleOrMultipleArray<Param>(isMultiple: item.isMultipleChoice)
        }
    }
    
    // MARK: - Methods
    func displayError(message: String) {
        print("Error: \(message)")
    }
}

// MARK: - UI Configuration
extension UniversitiesViewController {
    
    private func configureNavigationBar() {
        let backItem = UIBarButtonItem(
            title: Constants.Strings.backButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backItem
        
        navigationItem.title = Constants.Strings.universitiesTitle
        
        guard let navigationController = self.navigationController as? NavigationBarViewController else {return}
        navigationController.searchButtonPressed = { [weak self] sender in
            self?.router?.routeToSearch()
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
            UniversityTableViewCell.self,
            forCellReuseIdentifier: UniversityTableViewCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Constants.Colors.tableViewBackground
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        
        let headerContainer = UIView()
        headerContainer.backgroundColor = .clear
        
        headerContainer.addSubview(filterSortView)
        
        filterSortView.pinTop(to: headerContainer.topAnchor, 13)
        filterSortView.pinLeft(to: headerContainer.leadingAnchor)
        filterSortView.pinRight(to: headerContainer.trailingAnchor)
        filterSortView.pinBottom(to: headerContainer.bottomAnchor)
        
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
            self?.loadUniversities()
            self?.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension UniversitiesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (universities.count != 0) ? universities.count : 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "UniversityTableViewCell",
            for: indexPath
        ) as? UniversityTableViewCell
        else {
            fatalError("Could not dequeue cell")
        }
        
        if universities.count != 0 {
            let universityViewModel = universities[indexPath.row]
            cell.configure(with: universityViewModel)
            cell.favoriteButtonTapped = { [weak self] sender, isFavorite in
                guard let self = self else { return }
                if isFavorite {
                    self.universities[indexPath.row].like = true
                    guard
                        let model = self.interactor?.universityModel(at: indexPath.row)
                    else { return }
                    
                    FavoritesManager.shared.addUniversityToFavorites(model: model)
                    
                } else {
                    self.universities[indexPath.row].like = false
                    FavoritesManager.shared.removeUniversityFromFavorites(universityID: sender.tag)
                }
            }
        } else {
            cell.configureShimmer()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let universityModel = interactor?.universities[indexPath.row] else { return }
        router?.routeToDetails(for: universityModel)
    }
}

extension UniversitiesViewController : UniversitiesDisplayLogic {
    func displayUniversities(viewModel: Universities.Load.ViewModel) {
        universities = viewModel.universities
        for i in 0..<universities.count {
            let universityID = universities[i].universityID
            let like = universities[i].like
            universities[i].like = isFavorite(univesityID: universityID, serverValue: like)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - OptionsViewControllerDelegate
extension UniversitiesViewController : OptionsViewControllerDelegate {
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
        
        selectedParams[paramType] = filterItems[index].selectedParams
        
        loadUniversities()
    }
}

// MARK: - Filterble
extension UniversitiesViewController : Filterble {
    func deleteFilter(forItemAt index: Int) {
        let item = filterItems[index]
        selectedParams[item.paramType]?.clear()
        loadUniversities()
    }
}


// MARK: - Combine
extension UniversitiesViewController {
    private func setupBindings() {
        FavoritesManager.shared.universityEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(let updatedUniversity):
                    if let index = self.universities.firstIndex(where: {
                        $0.universityID == updatedUniversity.universityID
                    }) {
                        if self.universities[index].like == true { break }
                        self.universities[index].like = true
                        self.tableView.reloadRows(
                            at: [IndexPath(row: index, section: 0)],
                            with: .automatic
                        )
                    }
                case .removed(let universityID):
                    if let index = self.universities.firstIndex(where: { $0.universityID == universityID }) {
                        if self.universities[index].like == false { break }
                        self.universities[index].like = false
                        self.tableView.reloadRows(
                            at: [IndexPath(row: index, section: 0)],
                            with: .automatic
                        )
                    }
                case .error(let universityID):
                    if let index = self.universities.firstIndex(where: { $0.universityID == universityID }) {
                        if self.universities[index].like == self.interactor?.universities[index].like { break }
                        self.universities[index].like = self.interactor?.universities[index].like ?? false
                        self.tableView.reloadRows(
                            at: [IndexPath(row: index, section: 0)],
                            with: .automatic
                        )
                    }
                case .access(let universityID, let isFavorite):
                    if let index = self.interactor?.universities.firstIndex(where: { $0.universityID == universityID }) {
                        self.universities[index].like = isFavorite
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func isFavorite(univesityID: Int, serverValue: Bool) -> Bool {
        FavoritesManager.shared.isUniversityFavorited(
            universityID: univesityID,
            serverValue: serverValue
        )
    }
}
