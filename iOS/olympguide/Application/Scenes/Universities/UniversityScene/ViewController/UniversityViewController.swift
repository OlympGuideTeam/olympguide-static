//
//  UniversityViewController.swift
//  olympguide
//
//  Created by Tom Tim on 20.02.2025.
//

import UIKit
import SafariServices
import MessageUI
import Combine

// MARK: - UniversityViewController
final class UniversityViewController : UIViewController, WithBookMarkButton {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    var filterItems: [FilterItem] = []
    var selectedParams: [ParamType: SingleOrMultipleArray<Param>] = [:]
    let filterSortView: FilterSortView = FilterSortView()
    
    var interactor: (UniversityBusinessLogic & ProgramsBusinessLogic & ProgramsDataStore)?
    var router: ProgramsRoutingLogic?
    
    private lazy var dataSource = UniversityDataSource()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let informationStackView: InformationAboutUniStack = InformationAboutUniStack()
    
    private let universityID: Int
    private var isFavorite: Bool = false
    private let university: UniversityModel
    private var selectedSegmentIndex = 0
    
    var groupsOfPrograms : [GroupOfProgramsViewModel] = []
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private let tableView = UICustomTbleView(frame: .zero, style: .plain)
    
    init(for university: UniversityModel) {
        self.universityID = university.universityID
        self.university = university
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = university.shortName
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isFavorite = favoritesManager.isUniversityFavorited(
            universityID: universityID,
            serverValue: university.like ?? false
        )
        interactor?.isFavorite = isFavorite
        
        setupDataSource()
        setupFilterItems()
        setupAuthBindings()
        
        configureUI()
        
        loadUniversity()
        loadPrograms()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBookMarkButton()
    }
    
    private func configureBookMarkButton() {
        guard let navigationController = navigationController as? NavigationBarViewController else { return }
        let newImageName = isFavorite ? "bookmark.fill" :  "bookmark"
        navigationController.bookMarkButton.setImage(UIImage(systemName: newImageName), for: .normal)
        navigationController.bookMarkButtonPressed = {[weak self] sender in
            guard let self = self else { return }
            self.isFavorite.toggle()
            let newImageName = self.isFavorite ? "bookmark.fill" :  "bookmark"
            sender.setImage(UIImage(systemName: newImageName), for: .normal)
            
            if self.isFavorite {
                favoritesManager.addUniversityToFavorites(model: self.university)
            } else {
                favoritesManager.removeUniversityFromFavorites(universityID: self.universityID)
            }
        }
    }
    
    private func loadUniversity() {
        let request = University.Load.Request(universityID: universityID)
        interactor?.loadUniversity(with: request)
    }
    
    private func loadPrograms() {
        dataSource.isShimmering = true
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        var request = Programs.Load.Request(
            params: selectedParams,
            university: university
        )
        if self.selectedSegmentIndex == 1 {
            request.groups = .faculties
        }
        
        self.interactor?.loadPrograms(with: request)
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
}

// MARK: - UI Configuration
extension UniversityViewController {
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        configureInformationStack()
        setupFilterSortView()
        
        configureRefreshControl()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let backItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    private func reloadFavoriteButton() {
        guard let navigationController = navigationController as? NavigationBarViewController else { return }
        let newImageName = isFavorite ? "bookmark.fill" :  "bookmark"
        navigationController.bookMarkButton.setImage(UIImage(systemName: newImageName), for: .normal)
    }
    
    private func configureInformationStack() {
        informationStackView.configure(
            university: university,
            filterSortView: filterSortView
        )
        
        informationStackView.searchButtonAction = { [weak self] in
            self?.router?.routeToSearch()
        }
        
        informationStackView.segmentChanged = { [weak self] segment in
            self?.selectedSegmentIndex = segment.selectedSegmentIndex
            self?.loadPrograms()
        }
    }

    func configureRefreshControl() {
        refreshControl.tintColor = .systemCyan
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        dataSource.register(in: tableView)
        
        tableView.refreshControl = refreshControl
        
        tableView.addHeaderView(informationStackView)
    }
}

// MARK: - UniversityDisplayLogic
extension UniversityViewController : UniversityDisplayLogic {
    func displayftSetFavorite(to isFavorite: Bool) {
        self.isFavorite = isFavorite
        self.reloadFavoriteButton()
    }
    
    // TODO: - What? Why?....
    func displayToggleFavoriteResult(with viewModel: University.Favorite.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: "Не удалось добавить ВУЗ в избранные" , with: viewModel.errorMessage)
        }
    }
    
    func displayLoadResult(with viewModel: University.Load.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.informationStackView.setEmail(viewModel.email)
            self?.informationStackView.setWebPage(viewModel.site)
        }
    }
}

// MARK: - ProgramsDisplayLogic
extension UniversityViewController : ProgramsDisplayLogic {
    func displayLoadProgramsResult(with viewModel: Programs.Load.ViewModel) {
        let expended: Set<String> = Set(groupsOfPrograms.compactMap { $0.isExpanded ? $0.field.code : nil })
        groupsOfPrograms = viewModel.groupsOfPrograms
        groupsOfPrograms.forEach {
            if expended.contains($0.field.code) {
                $0.isExpanded = true
            }
        }
        dataSource.isShimmering = false
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    func displaySetFavorite(at indexPath: IndexPath, _ isFavorite: Bool) {
        let (groupIndex, programIndex) = (indexPath.section, indexPath.row)
        if groupsOfPrograms[groupIndex].programs[programIndex].like != isFavorite {
            groupsOfPrograms[groupIndex].programs[programIndex].like = isFavorite
            self.tableView.reloadRows(
                at: [IndexPath(row: programIndex, section: groupIndex)],
                with: .automatic
            )
        }
    }
}

// MARK: - UITableViewDataSource
extension UniversityViewController {
    private func setupDataSource() {
        dataSource.viewController = self
        
        dataSource.onProgramSelect = { [weak self] program in
            self?.router?.routeToProgram(with: program)
        }
        
        dataSource.onFavoriteProgramTapped = { [weak self] IndexPath, isFavorite in
            self?.favoriteProgramTapped(IndexPath, isFavorite)
        }
    }
    
    private func favoriteProgramTapped(_ indexPath: IndexPath, _ isFavorite: Bool) {
        groupsOfPrograms[indexPath.section].programs[indexPath.row].like = isFavorite
        let viewModel = groupsOfPrograms[indexPath.section].programs[indexPath.row]
        if isFavorite {
            guard
                let model = interactor?.program(at: indexPath)
            else { return }
            favoritesManager.addProgramToFavorites(university, model)
        } else {
            groupsOfPrograms[indexPath.section].programs[indexPath.row].like = false
            favoritesManager.removeProgramFromFavorites(programID: viewModel.programID)
        }
    }
    
    @objc private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            loadPrograms()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - OptionsViewControllerDelegate
extension UniversityViewController : OptionsViewControllerDelegate {
    func didSelectOption(
        _ indices: Set<Int>,
        _ options: [OptionViewModel],
        paramType: ParamType?
    ) {
        guard let paramType = paramType else { return }
        guard let index = filterItems.firstIndex(where: { $0.paramType == paramType }) else { return }
        
        filterItems[index].selectedIndices = indices
        
        filterItems[index].selectedParams.clear()
        for option in options {
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
extension UniversityViewController : Filterble {
    func deleteFilter(forItemAt index: Int) {
        let item = filterItems[index]
        selectedParams[item.paramType]?.clear()
        loadPrograms()
    }
}

// MARK: - Combine
extension UniversityViewController {
    private func setupAuthBindings() {
        authManager.isAuthenticatedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuth in
                if isAuth {
                    self?.loadUniversity()
                    self?.loadPrograms()
                }
            }.store(in: &cancellables)
    }
}
