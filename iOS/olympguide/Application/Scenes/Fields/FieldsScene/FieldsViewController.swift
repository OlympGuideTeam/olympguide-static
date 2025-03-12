//
//  FieldsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 11.01.2025.
//

import UIKit

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
        static let titleLabelTopMargin: CGFloat = 25
        static let titleLabelLeftMargin: CGFloat = 20
        static let searchButtonSize: CGFloat = 33
        static let searchButtonRightMargin: CGFloat = 20
        static let tableViewTopMargin: CGFloat = 13
    }
    
    enum Strings {
        static let fieldsTitle = "Направления"
        static let backButtonTitle = "   "
    }
    
    enum Images {
        static let searchIcon: String = "magnifyingglass"
    }
}

class FieldsViewController: UIViewController, WithSearchButton {
    // MARK: - VIP
    var interactor: (FieldsDataStore & FieldsBusinessLogic)?
    var router: FieldsRoutingLogic?
    
    var filterItems: [FilterItem] = []
    
    var fieldItems: [FieldItem] {
        var result: [FieldItem] = []
        for (groupIndex, group) in fields.enumerated() {
            result.append(.header(group))
            if group.isExpanded {
                for (fieldIndex, dubField) in group.fields.enumerated() {
                    autoreleasepool {
                        let indexPath = IndexPath(row: fieldIndex, section: groupIndex)
                        result.append(.field(dubField, indexPath))
                    }
                }
            }
        }
        return result
    }
    private var selectedParams: [ParamType: SingleOrMultipleArray<Param>] = [:]
    
    // MARK: - Variables
    private let tableView = UITableView()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    lazy var filterSortView: FilterSortView = FilterSortView()
    
    private var fields: [GroupOfFieldsViewModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterItems()
        configureUI()
        loadFields()
        
        let backItem = UIBarButtonItem(
            title: Constants.Strings.backButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backItem
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
    
    private func loadFields() {
        let request = Fields.Load.Request(params: selectedParams)
        interactor?.loadFields(request)
    }
    
    private func setupFilterItems() {
        let regionFilterItem = FilterItem(
            paramType: .degree,
            title: "Формат обучения",
            initMethod: .models([
                OptionViewModel(id: 1, name: "Бакалавриат"),
                OptionViewModel(id: 2, name: "Специалитет")
            ]),
            isMultipleChoice: true
        )
        
        filterItems = [
            regionFilterItem
        ]
        
        for item in filterItems {
            selectedParams[item.paramType] = SingleOrMultipleArray<Param>(isMultiple: item.isMultipleChoice)
        }
    }
    
    func displayError(message: String) {
        print("Error: \(message)")
    }
}

// MARK: - UI Configuration
extension FieldsViewController {
    
    private func configureUI() {
        configureNavigationBar()
        configureRefreshControl()
        setupFilterSortView()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = Constants.Strings.fieldsTitle
        
        if let navigationController = self.navigationController as? NavigationBarViewController {
            navigationController.searchButtonPressed = { [weak self] _ in
                self?.router?.routeToSearch()
            }
        }
    }
    
    func configureRefreshControl() {
        refreshControl.tintColor = Constants.Colors.refreshTint
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 50,
            right: 0
        )
        
        tableView.register(
            FieldTableViewCell.self,
            forCellReuseIdentifier: FieldTableViewCell.identifier
        )
        tableView.register(
            UIFieldHeaderCell.self,
            forCellReuseIdentifier: UIFieldHeaderCell.identifier
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Constants.Colors.tableViewBackground
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = true
        
        let headerContainer = UIView()
        headerContainer.backgroundColor = .clear
        
        headerContainer.addSubview(filterSortView)
        
        filterSortView.pinTop(to: headerContainer.topAnchor, Constants.Dimensions.tableViewTopMargin)
        filterSortView.pinLeft(to: headerContainer.leadingAnchor)
        filterSortView.pinRight(to: headerContainer.trailingAnchor)
        filterSortView.pinBottom(to: headerContainer.bottomAnchor, 21)
        
        headerContainer.setNeedsLayout()
        headerContainer.layoutIfNeeded()
        
        let targetSize = CGSize(
            width: tableView.bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        let fittingSize = headerContainer.systemLayoutSizeFitting(targetSize)
        headerContainer.frame.size.height = fittingSize.height
        tableView.tableHeaderView = headerContainer
        
        tableView.tableHeaderView = headerContainer
    }
    
    // MARK: - Actions
    @objc
    private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            [weak self] in
            self?.loadFields()
            self?.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension FieldsViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return fieldItems.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let item = fieldItems[indexPath.row]
        
        switch item {
        case .header(let group):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: UIFieldHeaderCell.identifier,
                for: indexPath
            ) as? UIFieldHeaderCell
            else {
                return UITableViewCell()
            }
            
            cell.configure(
                with: group.mainField,
                isExpanded: group.isExpanded
            )
            
            return cell
        case .field(let field, _):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FieldTableViewCell.identifier,
                for: indexPath
            ) as? FieldTableViewCell
            else {
                return UITableViewCell()
            }
            
            cell.configure(with: field)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension FieldsViewController: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let item = fieldItems[indexPath.row]

        switch item {
            case .header(let group):
                toggleSection(at: indexPath, group: group, in: tableView)
            case .field(_, let realIndexPath):
            tableView.deselectRow(at: indexPath, animated: true)
            router?.routeToField(for: realIndexPath)
        }
    }
    
    func toggleSection(
        at indexPath: IndexPath,
        group: GroupOfFieldsViewModel,
        in tableView: UITableView
    ) {
        let toggleIndex = indexPath.row
        let fieldsCount = group.fields.count
        
        tableView.beginUpdates()
        
        if group.isExpanded {
            group.isExpanded = false
            var indexPathsToDelete: [IndexPath] = []
            
            for i in 1...fieldsCount {
                indexPathsToDelete.append(IndexPath(row: toggleIndex + i, section: 0))
            }
            
            tableView.deleteRows(at: indexPathsToDelete, with: .fade)
        }
        else {
            group.isExpanded = true

            var indexPathsToInsert: [IndexPath] = []
            for i in 1...fieldsCount {
                indexPathsToInsert.append(IndexPath(row: toggleIndex + i, section: 0))
            }
            tableView.insertRows(at: indexPathsToInsert, with: .fade)
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class ReusableHeader: UITableViewHeaderFooterView {
    override func prepareForReuse() {
        super.prepareForReuse()
        print("Header is about to be reused!")
    }
}


// MARK: - FieldsDisplayLogic
extension FieldsViewController : FieldsDisplayLogic {
    func displayFields(viewModel: Fields.Load.ViewModel) {
        fields = viewModel.groupsOfFields
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}


extension FieldsViewController : Filterble {
    func deleteFilter(forItemAt index: Int) {
        let item = filterItems[index]
        selectedParams[item.paramType]?.clear()
        
        loadFields()
    }
}

extension FieldsViewController : OptionsViewControllerDelegate {
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
        
        let request = Fields.Load.Request(params: selectedParams)
        interactor?.loadFields(request)
    }
}
