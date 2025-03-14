//
//  FavoriteUniversitiesViewController.swift
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
    
    enum Dimensions {
        static let titleLabelTopMargin: CGFloat = 25
        static let titleLabelLeftMargin: CGFloat = 20
        static let searchButtonSize: CGFloat = 33
        static let searchButtonRightMargin: CGFloat = 20
        static let tableViewTopMargin: CGFloat = 13
    }
    
    enum Strings {
        static let universitiesTitle = "Избранные ВУЗы"
        static let backButtonTitle = "Избранные"
    }
    
    enum Images {
        static let searchIcon: String =  "magnifyingglass"
    }
}

class FavoriteUniversitiesViewController : UIViewController {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
    // MARK: - VIP
    var interactor: (UniversitiesDataStore & UniversitiesBusinessLogic)?
    var router: UniversitiesRoutingLogic?
    
    // MARK: - Variables
    private let tableView = UITableView()
    private let titleLabel: UILabel = UILabel()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    private var universities: [UniversityViewModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureRefreshControl()
        configureTableView()
        
        let request = Universities.Load.Request(params: .init())
        interactor?.loadUniversities(with: request)
        
        let backItem = UIBarButtonItem(title: Constants.Strings.backButtonTitle, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }

    private func configureNavigationBar() {
        navigationItem.title = Constants.Strings.universitiesTitle
        
        if let navigationController = self.navigationController as? NavigationBarViewController {
            navigationController.searchButtonPressed = { [weak self] sender in
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
        
        tableView.register(
            UniversityTableViewCell.self,
            forCellReuseIdentifier: "UniversityTableViewCell"
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Constants.Colors.tableViewBackground
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
    }
    
    @objc
    private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let request = Universities.Load.Request(params: .init())
            self.interactor?.loadUniversities(with: request)
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoriteUniversitiesViewController : UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return universities.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UniversityTableViewCell.identifier,
            for: indexPath
        ) as? UniversityTableViewCell else {
            fatalError()
        }
        
        let universityViewModel = universities[indexPath.row]
        cell.configure(with: universityViewModel)
        
        cell.favoriteButtonTapped = { [weak self] sender, isFavorite in
            if !isFavorite {
                self?.favoritesManager.removeUniversityFromFavorites(universityID: sender.tag)
            }
        }
        
        cell.hideSeparator(indexPath.row == (universities.count - 1))
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteUniversitiesViewController : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        router?.routeToUniversity(for: indexPath.row)
    }
}

// MARK: - UniversitiesDisplayLogic
extension FavoriteUniversitiesViewController: UniversitiesDisplayLogic {
    func displayUniversities(with viewModel: Universities.Load.ViewModel) {
        universities = viewModel.universities
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.tableView.backgroundView = getEmptyLabel()
            
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func getEmptyLabel() -> UILabel? {
        guard universities.isEmpty else { return nil }
        
        let emptyLabel = UILabel(frame: self.tableView.bounds)
        emptyLabel.text = "Избранных ВУЗов пока нет"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .black
        emptyLabel.font = FontManager.shared.font(for: .emptyTableLabel)
        
        return emptyLabel
    }
 
    func displaySetFavorite(at index: Int, isFavorite: Bool) {
        if isFavorite {
            guard
                var viewModel = interactor?.universityModel(at: index).toViewModel()
            else { return }
            
            viewModel.like = true
            universities.insert(viewModel, at: index)
            let newIndex = IndexPath(row: index, section: 0)
            tableView.insertRows(at: [newIndex], with: .automatic)
            tableView.backgroundView = nil
        } else {
            universities.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            tableView.backgroundView = getEmptyLabel()
            if index == universities.count && index != 0 {
                let indexPath = IndexPath(row: index - 1, section: 0)
                if let cell = tableView.cellForRow(at: indexPath) as? UniversityTableViewCell {
                    cell.hideSeparator(true)
                }
            }
        }
    }
    
}

// MARK: - Combine
extension FavoriteUniversitiesViewController {
    func isFavorite(univesityID: Int, serverValue: Bool) -> Bool {
        favoritesManager.isUniversityFavorited(
            universityID: univesityID,
            serverValue: serverValue
        )
    }
}


