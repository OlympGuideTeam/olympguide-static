//
//  SearchViewController.swift
//  olympguide
//
//  Created by Tom Tim on 01.01.2025.
//

import UIKit

final class SearchViewController<Strategy: SearchStrategy>: UIViewController, NonTabBarVC, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - VIP
    var interactor: (SearchBusinessLogic)?
    var router: (SearchRoutingLogic)?
    
    // MARK: - Variables
    private let customSearchBar: CustomTextField
    private let tableView = UITableView()
    
    private var rawModels: [Strategy.ViewModelType] = []
    var strategy: Strategy?
    
    // MARK: - Lifecycle
    init(
        searchType: SearchType
    ) {
        self.customSearchBar = CustomTextField(with: searchType.title)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Поиск"
        navigationItem.largeTitleDisplayMode = .never
        
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customSearchBar.didTapSearchBar()
    }
    
    // MARK: - Methods
    private func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationController()
        configureSearchBar()
        configureTableView()
    }
    
    private func configureNavigationController() {
        navigationItem.largeTitleDisplayMode = .never
        let backItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    private func configureSearchBar() {
        customSearchBar.delegate = self
        view.addSubview(customSearchBar)
        
        customSearchBar.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        customSearchBar.pinLeft(to: view.leadingAnchor, 20)
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        strategy?.registerCells(in: tableView)
        
        tableView.pinTop(to: customSearchBar.bottomAnchor, 10)
        tableView.pinLeft(to: view.leadingAnchor)
        tableView.pinRight(to: view.trailingAnchor)
        tableView.pinBottom(to: view.bottomAnchor)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rawModels.count
    }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let strategy = self.strategy else {
                let cell = UITableViewCell(
                    style: .default,
                    reuseIdentifier: "cell"
                )
                return cell
            }
            
            let viewModel = rawModels[indexPath.row]
            return strategy.configureCell(
                tableView: tableView,
                indexPath: indexPath,
                viewMmodel: viewModel,
                isSeparatorHidden: indexPath.row == rawModels.count - 1
            )
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        router?.routeToDetails(to: indexPath.row)
    }
}

// MARK: - SearchDisplayLogic
extension SearchViewController: SearchDisplayLogic {
    func displayTextDidChange<ViewModel>(viewModel: Search.TextDidChange.ViewModel<ViewModel>) {
        guard let items = viewModel.items as? [Strategy.ViewModelType] else {
            return
        }
        rawModels = items
        tableView.reloadData()
    }
}

// MARK: - CustomTextFieldDelegate
extension SearchViewController: CustomTextFieldDelegate {
    func action(_ searchBar: CustomTextField, textDidChange text: String) {
        let request = Search.TextDidChange.Request(query: text)
        interactor?.textDidChange(request: request)
    }
}

