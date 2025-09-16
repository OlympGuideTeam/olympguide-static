//
//  DiplomaViewController.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 21.04.2025.
//

//
//  DiplomaViewController.swift
//  olympguide
//
//  Created by Tom Tim on 01.03.2025.
//

import UIKit
import Combine

final class DiplomaViewController: UIViewController {
    @InjectSingleton
    var filtersManager: FiltersManagerProtocol
    
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    var interactor: (DiplomaBusinessLogic & BenefitsByProgramsBusinessLogic)?
    var router: DiplomaRoutingLogic?
    
    var filterSortView: FilterSortView = FilterSortView()
    var filterItems: [FilterItem] = []
    var selectedParams: [ParamType: SingleOrMultipleArray<Param>] = [:]
    
    var groups: [UniWithProgramsWithBenefits] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    private let diploma: DiplomaModel
    private let informationStackView: InformationAboutDiplomaStack = InformationAboutDiplomaStack()
    
    private let tableView: UICustomTbleView = UICustomTbleView()
    private let dataSource: DiplomaDataSource = DiplomaDataSource()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
        
    init(with diploma: DiplomaModel) {
        self.diploma = diploma
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        setupFilterItems()
        configureUI()
        let request = Diploma.LoadUniversities.Request()
        interactor?.loadUniversities(with: request)
    }
    
    private func loadPrograms() {
        for (section, group) in groups.enumerated() {
            if group.isExpanded {
                let request = BenefitsByPrograms.Load.Request(
                    olympiadID: 0,
                    universityID: groups[section].university.universityID,
                    section: section,
                    params: selectedParams
                )
                interactor?.loadBenefits(with: request)
            }
        }
    }
    
    private func setupFilterItems() {
        filterItems = filtersManager.getData(for: type(of: self))
        for item in filterItems {
            selectedParams[item.paramType] = SingleOrMultipleArray<Param>(isMultiple: item.isMultipleChoice)
        }
    }
}

// MARK: - UI Configuration
extension DiplomaViewController {
    private func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationBar()
        
        setupFilterSortView()
        configureInformatonStack()
        
        configureRefreshControl()
        configureTableView()
    }
    
    private func configureInformatonStack() {
        informationStackView.configure(diploma, filterSortView)
        informationStackView.searchButtonAction = { [weak self] in
            guard let self else { return }
            router?.routeToSearch()
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let backItem = UIBarButtonItem(title: "Диплом", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
    
        dataSource.register(in: tableView)
        
        tableView.refreshControl = refreshControl

        tableView.addHeaderView(informationStackView)
    }
    
    func configureRefreshControl() {
        refreshControl.tintColor = .systemCyan
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            loadPrograms()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension DiplomaViewController {
    private func setupDataSource() {
        dataSource.viewController = self
        
        dataSource.onProgramSelect = { [weak self] indexPath in
            self?.router?.routeToProgram(indexPath: indexPath)
        }
        
        dataSource.onSectionToggle = { [weak self] section in
            self?.toggleSection(at: section)
        }
        
    }
    
    private func toggleSection(at index: Int) {
        
        if !groups[index].isExpanded {
            let request = BenefitsByPrograms.Load.Request(
                olympiadID: 0,
                universityID: groups[index].university.universityID,
                section: index,
                params: selectedParams
            )
            interactor?.loadBenefits(with: request)
        }
    }
}

// MARK: - OlympiadDisplayLogic
extension DiplomaViewController : DiplomaDisplayLogic {
    func displayLoadUniversitiesResult(with viewModel: Diploma.LoadUniversities.ViewModel) {
        groups = viewModel.universities.map {
            UniWithProgramsWithBenefits(university: $0)
        }
        
        informationStackView.searchButton.isEnabled = true
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: - BenefitsByProgramsDisplayLogic
extension DiplomaViewController : BenefitsByProgramsDisplayLogic {
    func displayLoadBenefitsResult(with viewModel: BenefitsByPrograms.Load.ViewModel) {
        groups[viewModel.section].programs = viewModel.benefits
        let id = groups[viewModel.section].university.universityID
        if !dataSource.toggle(to: id, in: tableView) {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}

extension DiplomaViewController : OptionsViewControllerDelegate {
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
        
        loadPrograms()
    }
}

// MARK: - Filterble
extension DiplomaViewController : Filterble {
    func deleteFilter(forItemAt index: Int) {
        let item = filterItems[index]
        selectedParams[item.paramType]?.clear()
        
        loadPrograms()
    }
}
