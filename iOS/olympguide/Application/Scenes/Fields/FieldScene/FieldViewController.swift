//
//  FieldViewController.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit
import Combine

final class FieldViewController: UIViewController {
    @InjectSingleton
    var favoritesManager: FavoritesManagerProtocol
    
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    var interactor: FieldBusinessLogic?
    var router: FieldRoutingLogic?
    
    var filterSortView: FilterSortView = FilterSortView()
    var filterItems: [FilterItem] = []
    var selectedParams: [ParamType: SingleOrMultipleArray<Param>] = [:]
    
    private let field: GroupOfFieldsModel.FieldModel
    
    private let informationStackView: UIStackView = UIStackView()
    private let tableView: UITableView = UITableView()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    var programs: [ProgramsByUniversityViewModel] = []
    
    init(for field: GroupOfFieldsModel.FieldModel) {
        self.field = field
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFilterItems()
        setupFilterSortView()
        configureUI()
        loadPrograms()
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
    
    func loadPrograms() {
        let request = Field.LoadPrograms.Request(
            fieldID: field.fieldId,
            params: selectedParams
        )
        interactor?.loadPrograms(with: request)
    }
}

// MARK: - UI Configurations
extension FieldViewController {
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureInformationStackView()
        configureNameLabel()
        configureDegreeLabel()
        configureProgramsTitleLabel()
        configureFilterSortView()
        configureLastSpace()
        configureRefreshControl()
        configureTableView()
        configureLastSpace()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        title = field.code
        let backItem = UIBarButtonItem(
            title: field.code,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backItem
    }
    
    private func configureInformationStackView() {
        informationStackView.axis = .vertical
        informationStackView.alignment = .fill
        informationStackView.distribution = .fill
        informationStackView.isLayoutMarginsRelativeArrangement = true
        informationStackView.layoutMargins = UIEdgeInsets(
            top: 10,
            left: 20,
            bottom: 0,
            right: 20
        )
    }
    
    private func configureNameLabel() {
        let nameLabel = UILabel()
        nameLabel.textColor = .black
        nameLabel.font = FontManager.shared.font(weight: .medium, size: 17.0)
        nameLabel.text = field.name
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.calculateHeight(with: view.frame.width - 20 - 20)
        informationStackView.addArrangedSubview(nameLabel)
    }
    
    private func configureDegreeLabel() {
        informationStackView.pinToPrevious(17)
        let degreeLabel = UILabel()
        degreeLabel.textColor = .black
        degreeLabel.font = FontManager.shared.font(for: .additionalInformation)
        degreeLabel.text = "Степень: \(field.degree)"
        degreeLabel.calculateHeight(with: view.frame.width - 20 - 20)
        informationStackView.addArrangedSubview(degreeLabel)
    }
    
    private func configureProgramsTitleLabel() {
        informationStackView.pinToPrevious(17)
        let programsTitleLabel: UILabel = UILabel()
        programsTitleLabel.text = "Программы"
        programsTitleLabel.font = FontManager.shared.font(for: .tableTitle)
        programsTitleLabel.textColor = .black
        programsTitleLabel.calculateHeight(with: view.frame.width - 20 - 20)
        informationStackView.addArrangedSubview(programsTitleLabel)
        
        let searchButton = getSearchButton()
        
        searchButton.action = { [weak self] in
            guard let self else { return }
            self.router?.routeToSearch(fieldId: self.field.fieldId)
        }
        informationStackView.addSubview(searchButton)
        searchButton.pinRight(to: informationStackView.trailingAnchor, 20)
        searchButton.pinCenterY(to: programsTitleLabel)
    }
    
    private func getSearchButton() -> UIClosureButton {
        let searchButton = UIClosureButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .black
        searchButton.contentHorizontalAlignment = .fill
        searchButton.contentVerticalAlignment = .fill
        searchButton.imageView?.contentMode = .scaleAspectFit
        
        
        searchButton.setWidth(28)
        searchButton.setHeight(28)
        
        return searchButton
    }
    
    private func configureFilterSortView() {
        informationStackView.pinToPrevious(13)
        
        informationStackView.addArrangedSubview(filterSortView)
        filterSortView.pinLeft(to: informationStackView.leadingAnchor)
    }
    
    private func configureLastSpace() {
        let spaceView = UIView()
        spaceView.setHeight(5)
        
        informationStackView.addArrangedSubview(spaceView)
    }
    
    private func configureRefreshControl() {
        refreshControl.tintColor = .systemCyan
        refreshControl.addTarget(
            self,
            action: #selector(handleRefresh),
            for: .valueChanged
        )
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        tableView.register(
            ProgramTableViewCell.self,
            forCellReuseIdentifier: ProgramTableViewCell.identifier
        )
        
        tableView.register(
            UIUniversityHeader.self,
            forHeaderFooterViewReuseIdentifier: UIUniversityHeader.identifier
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
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
    
    // MARK: - Actions
    @objc
    private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            loadPrograms()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
extension FieldViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return programs.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        programs[section].isExpanded ? programs[section].programs.count : 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProgramTableViewCell.identifier
        ) as? ProgramTableViewCell
        else { return UITableViewCell() }
        
        cell.configure(with: programs[indexPath.section].programs[indexPath.row])
        cell.favoriteButtonTapped = { [weak self] sender, isFavorite in
            if !isFavorite {
                self?.favoritesManager.removeProgramFromFavorites(programID: sender.tag)
            } else {
                guard
                    let self,
                    let university = self.interactor?.getUniversity(at: indexPath.row),
                    let program = self.interactor?.getProgram(at: indexPath)
                else { return }
                favoritesManager.addProgramToFavorites(university, program)
            }
        }
        cell.hideSeparator(indexPath.row == programs[indexPath.section].programs.count - 1)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FieldViewController : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        router?.routeToProgram(indexPath: indexPath)
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: UIUniversityHeader.identifier
        ) as? UIUniversityHeader
        else { return nil }
        
        header.configure(
            with: programs[section].university,
            isExpanded: programs[section].isExpanded
        )
        
        header.tag = section
        
        header.toggleSection = { [weak self] section in
            guard let self = self else { return }
            var currentOffset = tableView.contentOffset
            let headerRectBefore = tableView.rectForHeader(inSection: section)
            
            programs[section].isExpanded.toggle()
            
            UIView.performWithoutAnimation {
                tableView.reloadSections(IndexSet(integer: section), with: .none)
                tableView.layoutIfNeeded()
            }
            let headerRectAfter = tableView.rectForHeader(inSection: section)
            
            let deltaY = headerRectAfter.origin.y - headerRectBefore.origin.y
            currentOffset.y += deltaY
            tableView.setContentOffset(currentOffset, animated: false)
        }
        return header
    }
}

// MARK: - FieldDisplayLogic
extension FieldViewController : FieldDisplayLogic {
    func displayLoadProgramsResult(with viewModel: Field.LoadPrograms.ViewModel) {
        programs = viewModel.programs
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
}

extension FieldViewController: OptionsViewControllerDelegate {
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


extension FieldViewController : Filterble {
    func deleteFilter(forItemAt index: Int) {
        let item = filterItems[index]
        selectedParams[item.paramType]?.clear()
        loadPrograms()
    }
}

// MARK: - Combine
extension FieldViewController {
    private func setupAuthBindings() {
        authManager.isAuthenticatedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuth in
                if isAuth {
                    self?.loadPrograms()
                }
            }.store(in: &cancellables)
    }
    
    private func setupProgramsBindings() {
        favoritesManager.programEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .added(_, let program):
                    guard
                        let indexPath = interactor?.getIndexPath(to: program.programID)
                    else { return }
                    if programs[indexPath.section].programs[indexPath.row].like == true { return }
                    programs[indexPath.section].programs[indexPath.row].like = true
        
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    
                case .removed(let programId):
                    guard
                        let indexPath = interactor?.getIndexPath(to: programId)
                    else { return }
                    
                    if programs[indexPath.section].programs[indexPath.row].like == false { return }
                    programs[indexPath.section].programs[indexPath.row].like = false
        
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                case .error(let programId):
                    guard
                        let indexPath = interactor?.getIndexPath(to: programId)
                    else { return }

                    if programs[indexPath.section].programs[indexPath.row].like == interactor?.restoreFavorite(at: indexPath) {
                        return
                    }
                    programs[indexPath.section].programs[indexPath.row].like = interactor?.restoreFavorite(at: indexPath) ?? false
                    
                    
                case .access(let programId, let isFavorite):
                    interactor?.setFavorite(to: programId, isFavorite: isFavorite)
                }
            }.store(in: &cancellables)
    }
}
