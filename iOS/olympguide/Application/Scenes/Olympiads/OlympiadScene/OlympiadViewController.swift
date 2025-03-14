//
//  OlympiadViewController.swift
//  olympguide
//
//  Created by Tom Tim on 01.03.2025.
//

import UIKit
import Combine

final class OlympiadViewController: UIViewController, WithBookMarkButton {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    var interactor: (OlympiadBusinessLogic & BenefitsByProgramsBusinessLogic)?
    var router: OlympiadRoutingLogic?
    
    var filterSortView: FilterSortView = FilterSortView()
    var filterItems: [FilterItem] = []
    var selectedParams: [ParamType: SingleOrMultipleArray<Param>] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    private let olympiad: OlympiadModel
    private let informationStackView: InformationAboutOlympStack = InformationAboutOlympStack()
    
    private let tableView: UICustomTbleView = UICustomTbleView()
    private let dataSource: OlympiadDataSource = OlympiadDataSource()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    var universities: [UniversityViewModel] = []
    var isExpanded: [Bool] = []
    var programs: [[ProgramWithBenefitsViewModel]] = []
    
    private var isFavorite: Bool = false
    
    init(with olympiad: OlympiadModel) {
        self.olympiad = olympiad
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isFavorite = favoritesManager.isOlympiadFavorite(
            olympiadId: olympiad.olympiadID,
            serverValue: olympiad.like
        )
        interactor?.isFavorite = isFavorite
        setupDataSource()
        setupFilterItems()
        configureUI()
        let request = Olympiad.LoadUniversities.Request(olympiadID: olympiad.olympiadID)
        interactor?.loadUniversities(with: request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController as? NavigationBarViewController else { return }
        let newImageName = isFavorite ? "bookmark.fill" :  "bookmark"
        navigationController.bookMarkButton.setImage(UIImage(systemName: newImageName), for: .normal)
        navigationController.bookMarkButtonPressed = {[weak self] sender in
            guard let self = self else { return }
            self.isFavorite.toggle()
            let newImageName = self.isFavorite ? "bookmark.fill" :  "bookmark"
            sender.setImage(UIImage(systemName: newImageName), for: .normal)
            
            if self.isFavorite {
                favoritesManager.addOlympiadToFavorites(model: olympiad)
            } else {
                favoritesManager.removeOlympiadFromFavorites(olympiadId: self.olympiad.olympiadID)
            }
        }
    }
    
    private func loadPrograms() {
        for (section, expand) in self.isExpanded.enumerated() {
            if expand {
                let request = BenefitsByPrograms.Load.Request(
                    olympiadID: olympiad.olympiadID,
                    universityID: universities[section].universityID,
                    section: section,
                    params: selectedParams
                )
                interactor?.loadBenefits(with: request)
            }
        }
    }
    
    private func setupFilterItems() {
        let benefitFilterItem = FilterItem(
            paramType: .benefit,
            title: "Льгота",
            initMethod: .models([
                OptionViewModel(id: 1, name: "БВИ"),
                OptionViewModel(id: 2, name: "100 баллов")
            ]),
            isMultipleChoice: true
        )
        
        let minDiplomaLevelFilterItem = FilterItem(
            paramType: .minClass,
            title: "Минимальный класс диплома",
            initMethod: .models([
                OptionViewModel(id: 10, name: "10 класс"),
                OptionViewModel(id: 11, name: "11 класс")
            ]),
            isMultipleChoice: true
        )
        
        let diplomaLevelFilterItem = FilterItem(
            paramType: .minDiplomaLevel,
            title: "Степень диплома",
            initMethod: .models([
                OptionViewModel(id: 1, name: "Победитель"),
                OptionViewModel(id: 3, name: "Призёр")
            ]),
            isMultipleChoice: true
        )
        
        filterItems = [
            benefitFilterItem,
            minDiplomaLevelFilterItem,
            diplomaLevelFilterItem
        ]
        
        for item in filterItems {
            selectedParams[item.paramType] = SingleOrMultipleArray<Param>(isMultiple: item.isMultipleChoice)
        }
    }
}

// MARK: - UI Configuration
extension OlympiadViewController {
    private func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationBar()
        
        setupFilterSortView()
        configureInformatonStack()
        
        configureRefreshControl()
        configureTableView()
    }
    
    private func configureInformatonStack() {
        informationStackView.configure(olympiad, filterSortView)
        informationStackView.searchButtonAction = { [weak self] in
            guard let self else { return }
            router?.routeToSearch(olympiadId: olympiad.olympiadID)
        }
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let backItem = UIBarButtonItem(title: "Олимпиада", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    private func reloadFavoriteButton() {
        guard let navigationController = navigationController as? NavigationBarViewController else { return }
        let newImageName = isFavorite ? "bookmark.fill" :  "bookmark"
        navigationController.bookMarkButton.setImage(UIImage(systemName: newImageName), for: .normal)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
                
        tableView.register(
            UIProgramWithBenefitsCell.self,
            forCellReuseIdentifier: UIProgramWithBenefitsCell.identifier
        )
        
        tableView.register(
            UIUniversityHeader.self,
            forHeaderFooterViewReuseIdentifier: UIUniversityHeader.identifier
        )
        
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
        
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
extension OlympiadViewController {
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
        isExpanded[index].toggle()
        
        if isExpanded[index] {
            let request = BenefitsByPrograms.Load.Request(
                olympiadID: olympiad.olympiadID,
                universityID: universities[index].universityID,
                section: index,
                params: selectedParams
            )
            interactor?.loadBenefits(with: request)
        } else {
            reloadSectionWithoutAnimation(index)
        }
    }
}

// MARK: - OlympiadDisplayLogic
extension OlympiadViewController : OlympiadDisplayLogic {
    func displayLoadUniversitiesResult(with viewModel: Olympiad.LoadUniversities.ViewModel) {
        universities = viewModel.universities
        isExpanded = [Bool](repeating: false, count: universities.count)
        programs = [[ProgramWithBenefitsViewModel]] (repeating: [], count: universities.count)
        informationStackView.searchButton.isEnabled = true
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func displaySetFavorite(to isFavorite: Bool) {
        self.isFavorite = isFavorite
        reloadFavoriteButton()
    }
}

// MARK: - BenefitsByProgramsDisplayLogic
extension OlympiadViewController : BenefitsByProgramsDisplayLogic {
    func displayLoadBenefitsResult(with viewModel: BenefitsByPrograms.Load.ViewModel) {
        programs[viewModel.section] = viewModel.benefits
        
        reloadSectionWithoutAnimation(viewModel.section)
    }
    
    private func reloadSectionWithoutAnimation(_ section: Int) {
        var currentOffset = tableView.contentOffset
        let headerRectBefore = tableView.rectForHeader(inSection: section)
        
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet(integer: section), with: .none)
            tableView.layoutIfNeeded()
        }
        
        let headerRectAfter = tableView.rectForHeader(inSection: section)
        let deltaY = headerRectAfter.origin.y - headerRectBefore.origin.y
        currentOffset.y += deltaY
        tableView.setContentOffset(currentOffset, animated: false)
    }
}

extension OlympiadViewController : OptionsViewControllerDelegate {
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
        
        for (section, expand) in self.isExpanded.enumerated() {
            if expand {
                let request = BenefitsByPrograms.Load.Request(
                    olympiadID: olympiad.olympiadID,
                    universityID: universities[section].universityID,
                    section: section,
                    params: selectedParams
                )
                interactor?.loadBenefits(with: request)
            }
        }
    }
}

extension OlympiadViewController : Filterble {
    func deleteFilter(forItemAt index: Int) {
        let item = filterItems[index]
        selectedParams[item.paramType]?.clear()
        
        loadPrograms()
    }
}

// MARK: - Combine
extension OlympiadViewController {
    
}
