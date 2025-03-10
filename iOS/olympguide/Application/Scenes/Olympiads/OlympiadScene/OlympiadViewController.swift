//
//  OlympiadViewController.swift
//  olympguide
//
//  Created by Tom Tim on 01.03.2025.
//

import UIKit
import Combine

final class OlympiadViewController: UIViewController, WithBookMarkButton {
    var interactor: (OlympiadBusinessLogic & BenefitsByProgramsBusinessLogic)?
    var router: OlympiadRoutingLogic?
    
    var filterSortView: FilterSortView = FilterSortView()
    var filterItems: [FilterItem] = []
    var selectedParams: [ParamType: SingleOrMultipleArray<Param>] = [:]
    
    private var cancellables = Set<AnyCancellable>()
    
    private let olympiad: OlympiadModel
    private let informationStackView: UIStackView = UIStackView()
    private let searchButton = UIClosureButton()
    private let tableView: UITableView = UITableView()
    
    private var universities: [UniversityViewModel] = []
    private var isExpanded: [Bool] = []
    private var programs: [[ProgramWithBenefitsViewModel]] = []
    
    private var isFavorite: Bool
    private var startIsFavorite: Bool
    
    init(with olympiad: OlympiadModel) {
        self.olympiad = olympiad
        
        self.isFavorite = FavoritesManager.shared.isOlympiadFavorite(
            olympiadId: olympiad.olympiadID,
            serverValue: olympiad.like
        )
        startIsFavorite = isFavorite
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                FavoritesManager.shared.addOlympiadToFavorites(model: olympiad)
            } else {
                FavoritesManager.shared.removeOlympiadFromFavorites(olympiadId: self.olympiad.olympiadID)
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
        setupOlympiadBindings()
        setupUniversityBindings()
        
        configureInformatonStack()
        configureOlympiadNameLabel()
        configureOlympiadInformation()
        configureProgramsLabel()
        setupFilterSortView()
        configureFilterSortView()
        
        configureTableView()
        
    }
    
    private func configureInformatonStack() {
        view.addSubview(informationStackView)
        informationStackView.axis = .vertical
        informationStackView.spacing = 17
        informationStackView.distribution = .fill
        informationStackView.alignment = .leading
        
        informationStackView.isLayoutMarginsRelativeArrangement = true
        informationStackView.layoutMargins = UIEdgeInsets(top: 15, left: 20, bottom: 0, right: 20)
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
    
    private func configureOlympiadInformation() {
        let olympiadInformationStack = UIStackView()
        
        olympiadInformationStack.axis = .vertical
        olympiadInformationStack.spacing = 7
        olympiadInformationStack.distribution = .fill
        olympiadInformationStack.alignment = .fill
        
        
        
        olympiadInformationStack.addArrangedSubview(configureLevelLabel())
        olympiadInformationStack.addArrangedSubview(configureProfileLabel())
        
        informationStackView.addArrangedSubview(olympiadInformationStack)
    }
    
    private func configureOlympiadNameLabel() {
        let olympiadNameLabel: UILabel = UILabel()
//        olympiadNameLabel.font = FontManager.shared.font(for: .commonInformation)
        olympiadNameLabel.font = FontManager.shared.font(weight: .medium, size: 17.0)
        olympiadNameLabel.numberOfLines = 0
        olympiadNameLabel.lineBreakMode = .byWordWrapping
        olympiadNameLabel.text = olympiad.name
        
        let labelWight = view.frame.width - 40
        olympiadNameLabel.calculateHeight(with: labelWight)
        informationStackView.addArrangedSubview(olympiadNameLabel)
    }
    
    private func configureLevelLabel() -> UILabel {
        let levelLabel: UILabel = UILabel()
        levelLabel.font = FontManager.shared.font(for: .additionalInformation)
        levelLabel.textColor = UIColor(hex: "#787878")
        levelLabel.text = "Уровень: \(String(repeating: "I", count: olympiad.level))"
        
        return levelLabel
    }
    
    private func configureProfileLabel() -> UILabel {
        let profileLabel: UILabel = UILabel()
        profileLabel.font = FontManager.shared.font(for: .additionalInformation)
        profileLabel.textColor = UIColor(hex: "#787878")
        profileLabel.numberOfLines = 0
        profileLabel.lineBreakMode = .byWordWrapping
        profileLabel.text = "Профиль: \(olympiad.profile)"
        let labelWight = view.frame.width - 40
        profileLabel.calculateHeight(with: labelWight)
        return profileLabel
    }
    
    private func configureProgramsLabel() {
        let programsLabel = UILabel()
        
        programsLabel.font = FontManager.shared.font(for: .tableTitle)
        programsLabel.textColor = .black
        programsLabel.text = "Программы"
        informationStackView.addArrangedSubview(programsLabel)
        
        let searchButton = getSearchButton()
        
        searchButton.action = { [weak self] in
            guard let self = self else { return }
            self.router?.routeToSearch(olympiadId: olympiad.olympiadID)
        }
        informationStackView.addSubview(searchButton)
        searchButton.pinRight(to: informationStackView.trailingAnchor, 20)
        searchButton.pinCenterY(to: programsLabel)
    }
    
    private func configureFilterSortView() {
        informationStackView.pinToPrevious(13 + 31 + 5)
        informationStackView.addArrangedSubview(UIView())
        
        informationStackView.addSubview(filterSortView)
        filterSortView.pinLeft(to: informationStackView.leadingAnchor)
        filterSortView.pinRight(to: informationStackView.trailingAnchor)
        filterSortView.pinBottom(to: informationStackView.bottomAnchor, 5)
    }
    
    private func getSearchButton() -> UIClosureButton {
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .black
        searchButton.contentHorizontalAlignment = .fill
        searchButton.contentVerticalAlignment = .fill
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.isEnabled = false
        
        searchButton.setWidth(28)
        searchButton.setHeight(28)
        
        return searchButton
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        tableView.register(
            UIProgramWithBenefitsCell.self,
            forCellReuseIdentifier: UIProgramWithBenefitsCell.identifier
        )
        
        tableView.register(
            UIUniversityHeader.self,
            forHeaderFooterViewReuseIdentifier: UIUniversityHeader.identifier
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        //        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        
        informationStackView.setNeedsLayout()
        informationStackView.layoutIfNeeded()
        
        let targetSize = CGSize(
            width: tableView.bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        let fittingSize = informationStackView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        informationStackView.frame.size.height = fittingSize.height
        
        tableView.tableHeaderView = informationStackView
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
    }
}

// MARK: - UITableViewDataSource
extension OlympiadViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return universities.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        isExpanded[section] ? programs[section].count : 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: UIProgramWithBenefitsCell.identifier
            ) as? UIProgramWithBenefitsCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: programs[indexPath.section][indexPath.row], indexPath: indexPath)
        for view in cell.benefitsStack.arrangedSubviews {
            guard let subview = view as? BenefitStackView else { continue }
            subview.createPreviewVC = { [weak self] indexPath, index in
                guard let self = self else { return nil }
                let program = self.programs[indexPath.section][indexPath.row]
                let previewVC = BenefitViewController(with: program, index: index)
                return previewVC
            }
        }
        
        cell.hideSeparator(indexPath.row == programs[indexPath.section].count - 1)
        return cell
    }
}


// MARK: - UITableViewDelegate
extension OlympiadViewController : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: UIUniversityHeader.identifier
        ) as? UIUniversityHeader else {
            return nil
        }
        
        headerView.configure(
            with: universities[section],
            isExpanded: isExpanded[section]
        )
        
        headerView.tag = section
        
        headerView.toggleSection = { [weak self] section in
            guard let self = self else { return }
            isExpanded[section].toggle()
            
            if isExpanded[section] {
                let request = BenefitsByPrograms.Load.Request(
                    olympiadID: olympiad.olympiadID,
                    universityID: universities[section].universityID,
                    section: section,
                    params: selectedParams
                )
                interactor?.loadBenefits(with: request)
            } else {
                reloadSectionWithoutAnimation(section)
            }
        }
        
        headerView.favoriteButtonTapped = { [weak self] sender, isFavorite in
            guard let self = self else { return }
            if isFavorite {
                self.universities[section].like = true
                guard
                    let model = self.interactor?.universityModel(at: section)
                else { return }
                
                FavoritesManager.shared.addUniversityToFavorites(model: model)
                
            } else {
                self.universities[section].like = false
                FavoritesManager.shared.removeUniversityFromFavorites(universityID: sender.tag)
            }
        }
        
        return headerView
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        router?.routeToProgram(indexPath: indexPath)
    }
    
}

// MARK: - OlympiadDisplayLogic
extension OlympiadViewController : OlympiadDisplayLogic {
    func displayLoadUniversitiesResult(with viewModel: Olympiad.LoadUniversities.ViewModel) {
        universities = viewModel.universities
        isExpanded = [Bool](repeating: false, count: universities.count)
        programs = [[ProgramWithBenefitsViewModel]] (repeating: [], count: universities.count)
        searchButton.isEnabled = true
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        
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

// MARK: - Combine
extension OlympiadViewController {
    private func setupOlympiadBindings() {
        FavoritesManager.shared.olympiadEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(let model):
                    if self.olympiad.olympiadID == model.olympiadID {
                        self.isFavorite = true
                    }
                case .removed(let olympiadId):
                    if self.olympiad.olympiadID == olympiadId {
                        self.isFavorite = false
                    }
                case .error(let olympiadId):
                    if self.olympiad.olympiadID == olympiadId {
                        self.isFavorite = startIsFavorite
                    }
                case .access(let olympiadId, let isFavorite):
                    if self.olympiad.olympiadID == olympiadId {
                        self.startIsFavorite = isFavorite
                    }
                }
                self.reloadFavoriteButton()
            }
            .store(in: &cancellables)
    }
    
    private func setupUniversityBindings() {
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
                        self.tableView.reloadSections(
                            IndexSet(integer: index),
                            with: .automatic
                        )
                    }
                case .removed(let universityID):
                    if let index = self.universities.firstIndex(where: { $0.universityID == universityID }) {
                        if self.universities[index].like == false { break }
                        self.universities[index].like = false
                        self.tableView.reloadSections(
                            IndexSet(integer: index),
                            with: .automatic
                        )
                    }
                case .error(let universityID):
                    if let index = self.universities.firstIndex(where: { $0.universityID == universityID }) {
                        if self.universities[index].like == self.interactor?.favoriteStatusAt(index: index) { break }
                        self.universities[index].like = self.interactor?.favoriteStatusAt(index: index) ?? false
                        self.tableView.reloadSections(
                            IndexSet(integer: index),
                            with: .automatic
                        )
                    }
                case .access(let universityID, let isFavorite):
                    self.interactor?.setFavoriteStatus(isFavorite, to: universityID)
                }
            }
            .store(in: &cancellables)
    }
}
