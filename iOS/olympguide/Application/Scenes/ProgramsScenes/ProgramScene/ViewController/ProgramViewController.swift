//
//  ProgramViewController.swift
//  olympguide
//
//  Created by Tom Tim on 25.02.2025.
//

import UIKit
import SafariServices
import Combine

fileprivate enum Constants {
    enum Dimensions {
        static let logoTopMargin: CGFloat = 30
        static let logoLeftMargin: CGFloat = 15
        static let logoSize: CGFloat = 80
        static let interItemSpacing: CGFloat = 20
        static let nameLabelBottomMargin: CGFloat = 20
        static let favoriteButtonSize: CGFloat = 22
        static let separatorHeight: CGFloat = 1
        static let separatorHorizontalInset: CGFloat = 20
    }
    
    enum Colors {
        static let separatorColor = UIColor(hex: "#E7E7E7")
        static let regionTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.53)
    }
    
    enum Fonts {
        static let nameLabelFont = FontManager.shared.font(for: .commonInformation)
        static let regionLabelFont = FontManager.shared.font(for: .region)
    }
}

final class ProgramViewController : UIViewController, WithBookMarkButton {
    @InjectSingleton
    var filtersManager: FiltersManagerProtocol
    
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
    var interactor: (ProgramBusinessLogic & BenefitsByOlympiadsBusinessLogic)?
    var router: (ProgramRoutingLogic /*& BenefitsByOlympiadsRoutingLogic*/)?
    
    var filterSortView: FilterSortView = FilterSortView()
    var filterItems: [FilterItem] = []
    private var selectedParams: [ParamType: SingleOrMultipleArray<Param>] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    var benefits: [OlympiadWithBenefitViewModel] = []
    
    private let programId: Int
    private var isFavorite: Bool?
    private let university: UniversityModel
    private var program: ProgramShortModel?
    private var link: String? = nil
    
    private let informationStack: InformationAboutProgramStack = InformationAboutProgramStack()
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private let tableView = UICustomTbleView(frame: .zero, style: .plain)
    private let dataSource: ProgramDataSource = ProgramDataSource()
    
    init(
        for programID: Int,
        name: String,
        code: String,
        university: UniversityModel
    ) {
        self.university = university
        self.programId = programID
        informationStack.configure(
            name: name,
            code: code,
            university: university,
            filterSortView: filterSortView
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    init (
        for program: ProgramModel
    ) {
        self.interactor?.isFavorite = program.like
        self.programId = program.programID
        self.university = program.university
        self.program = program.toShortModel()
        
        informationStack.configure(
            for: program.toShortModel(),
            by: program.university,
            with: filterSortView
        )
        
        var link = program.link
        link = link.replacingOccurrences(of: "https://www.", with: "")
            .replacingOccurrences(of: "https://", with: "")
        self.link = link
        
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(
        for program: ProgramShortModel,
        by university: UniversityModel
    ) {
        self.isFavorite = program.like
        self.interactor?.isFavorite = program.like
        self.university = university
        self.program = program
        self.programId = program.programID
        
        informationStack.configure(
            for: program,
            by: university,
            with: filterSortView
        )
        
        var link = program.link
        link = link.replacingOccurrences(of: "https://www.", with: "")
            .replacingOccurrences(of: "https://", with: "")
        
        self.link = link
        
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIsFavorite()
        setupDataSource()
        setupFilterItems()
        setupInformationStack()
        configureUI()
        loadOlympiads()
        interactor?.programId = programId
        if program == nil {
            let programRequest = Program.Load.Request(programID: programId)
            interactor?.loadProgram(with: programRequest)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureFavoriteButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard
            let navigationController = navigationController as? NavigationBarViewController
        else { return }
        navigationController.bookMarkButton.isEnabled = true
    }
    
    private func setupInformationStack() {
        informationStack.searchButtonAction = { [weak self] in
            guard let self else { return }
            router?.routeToSearch(programId: programId)
        }
    }
    
    private func setupIsFavorite() {
        if let program = program {
            self.isFavorite = favoritesManager.isProgramFavorited(
                programID: programId,
                serverValue: program.like
            )
            interactor?.isFavorite = self.isFavorite
        }
    }
    
    private func loadOlympiads() {
        dataSource.isShimmering = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            guard
                let self,
                dataSource.isShimmering == true
            else
            { return }
            tableView.reloadData()
        }
        let benefitRequest = BenefitsByOlympiads.Load.Request(
            programID: programId,
            params: selectedParams
        )
        interactor?.loadOlympiads(with: benefitRequest)
    }
    
    private func setupFilterItems() {
        filterItems = filtersManager.getData(for: type(of: self))
        
        for item in filterItems {
            selectedParams[item.paramType] = SingleOrMultipleArray<Param>(isMultiple: item.isMultipleChoice)
        }
    }
    
    private func configureFavoriteButton() {
        guard
            let navigationController = navigationController as? NavigationBarViewController
        else { return }
        
        guard
            let isFavorite = self.isFavorite
        else {
            navigationController.bookMarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
            navigationController.bookMarkButton.isEnabled = false
            return
        }
        navigationController.bookMarkButton.isEnabled = true
        let newImageName = isFavorite ? "bookmark.fill" :  "bookmark"
        navigationController.bookMarkButton.setImage(UIImage(systemName: newImageName), for: .normal)
        navigationController.bookMarkButtonPressed = {[weak self] sender in
            guard
                let self = self,
                let isFavorite = self.isFavorite,
                let program = self.program
            else { return }
            
            self.isFavorite = !isFavorite
            // TODO: -
            // self?.isFavorite.toggle()
            let newImageName = self.isFavorite ?? false ? "bookmark.fill" :  "bookmark"
            sender.setImage(UIImage(systemName: newImageName), for: .normal)
            
            if !isFavorite {
                favoritesManager.addProgramToFavorites(self.university, program)
            } else {
                favoritesManager.removeProgramFromFavorites(programID: program.programID)
            }
        }
    }
}

// MARK: - UI Configuration
extension ProgramViewController {
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        setupFilterSortView()
                
        configureRefreshControl()
        configureTableView()
        
        reloadFavoriteButton()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let backItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    func configureRefreshControl() {
        refreshControl.tintColor = .systemCyan
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        
        dataSource.register(in: tableView)
        
        tableView.refreshControl = refreshControl

        tableView.addHeaderView(informationStack)
    }
    
    func getEmptyLabel() -> UILabel? {
        guard benefits.isEmpty else { return nil }
        
        let emptyLabel = UILabel(frame: self.tableView.bounds)
        emptyLabel.text = "Подходящих льгот не найдено"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .black
        emptyLabel.font = FontManager.shared.font(for: .emptyTableLabel)
        
        return emptyLabel
    }
    
    @objc private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            loadOlympiads()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - DataSource
extension ProgramViewController {
    private func setupDataSource() {
        dataSource.viewController = self
        dataSource.onBenefitSelect = { [weak self] index in
            guard let benefit = self?.benefits[index] else { return }
            self?.router?.routToBenefit(benefit)
            
        }
    }
}

// MARK: - BenefitsDisplayLogic
extension ProgramViewController : BenefitsByOlympiadsDisplayLogic {
    func displayLoadOlympiadsResult(with viewModel: BenefitsByOlympiads.Load.ViewModel) {
        benefits = viewModel.benefits
        dataSource.isShimmering = false
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
//            self?.tableView.backgroundView = self?.getEmptyLabel()
        }
    }
}

// MARK: - ProgramDisplayLogic
extension ProgramViewController : ProgramDisplayLogic {
    func displayLoadProgram(with viewModel: Program.Load.ViewModel) {
        let link = viewModel.program.link
            .replacingOccurrences(of: "https://www.", with: "")
            .replacingOccurrences(of: "https://", with: "")
        self.link = link
        interactor?.isFavorite = viewModel.program.like
        informationStack.setInformation(viewModel.program)
        program = viewModel.program
        isFavorite = viewModel.program.like
        
        tableView.addHeaderView(informationStack)
        
        configureFavoriteButton()
    }
    
    func displayToggleFavoriteResult(viewModel: Program.Favorite.ViewModel) { }
    
    func displaySetFavorite(to isFavorite: Bool) {
        self.isFavorite = isFavorite
        reloadFavoriteButton()
    }
}

// MARK: - OptionsViewControllerDelegate
extension ProgramViewController : OptionsViewControllerDelegate {
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
        selectedParams[paramType] = filterItems[index].selectedParams
        
        loadOlympiads()
    }
}

// MARK: - Filterble
extension ProgramViewController : Filterble {
    func deleteFilter(forItemAt index: Int) {
        let item = filterItems[index]
        selectedParams[item.paramType]?.clear()
        
        loadOlympiads()
    }
}

// MARK: - Combine
extension ProgramViewController {
    private func reloadFavoriteButton() {
        guard let isFavorite = self.isFavorite else { return }
        guard let navigationController = navigationController as? NavigationBarViewController else { return }
        let newImageName = isFavorite ? "bookmark.fill" :  "bookmark"
        navigationController.bookMarkButton.setImage(UIImage(systemName: newImageName), for: .normal)
    }
}
