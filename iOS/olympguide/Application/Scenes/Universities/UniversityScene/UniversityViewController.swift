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

protocol WithBookMarkButton { }

// MARK: - UniversityViewController
final class UniversityViewController: UIViewController, WithBookMarkButton {
    var filterItems: [FilterItem] = []
    private var selectedParams: [ParamType: SingleOrMultipleArray<Param>] = [:]
    
    var interactor: (UniversityBusinessLogic & ProgramsBusinessLogic & ProgramsDataStore)?
    var router: ProgramsRoutingLogic?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let informationStackView: UIStackView = UIStackView()
    
    private let universityID: Int
    private var startIsFavorite: Bool
    private var isFavorite: Bool
    private let webSiteButton: UIInformationButton = UIInformationButton(type: .web)
    private let emailButton: UIInformationButton = UIInformationButton(type: .email)
    private let university: UniversityModel
    private let segmentedControl: UISegmentedControl = UISegmentedControl()
    let filterSortView: FilterSortView = FilterSortView()
    
    private var groupOfProgramsViewModel : [Programs.Load.ViewModel.GroupOfProgramsViewModel] = []
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let searchButton: UIClosureButton = {
        let button = UIClosureButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    init(for university: UniversityModel) {
        self.universityID = university.universityID
        self.isFavorite = FavoritesManager.shared.isUniversityFavorited(
            universityID: universityID,
            serverValue: university.like ?? false
        )
        self.startIsFavorite = isFavorite
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
        setupFilterItems()
        configureUI()
        
        webSiteButton.startShimmer()
        
        interactor?.loadUniversity(with: University.Load.Request(universityID: universityID))
        
        setupUniversityBindings()
        setupProgramsBindings()
        
        loadPrograms()
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
                FavoritesManager.shared.addUniversityToFavorites(model: self.university)
            } else {
                FavoritesManager.shared.removeUniversityFromFavorites(universityID: self.universityID)
            }
        }
    }
    
    private func loadPrograms() {
        var request = Programs.Load.Request(
            params: selectedParams,
            university: university
        )
        if self.segmentedControl.selectedSegmentIndex == 1 {
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
        configureUniversityView()
        configureWebSiteButton()
        configureEmailButton()
        configureProgramLabel()
        configureSegmentedControl()
        configureFilterSortView()
        configureLastSpace()
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
        informationStackView.axis = .vertical
        informationStackView.alignment = .fill
        informationStackView.distribution = .fill
        informationStackView.isLayoutMarginsRelativeArrangement = true
        informationStackView.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 20)
    }
    
    private func configureUniversityView() {
        let universityView = UIUniversityView()
        universityView.configure(with: university.toViewModel(), 20, 20)
        universityView.favoriteButtonIsHidden = true
        
        informationStackView.addArrangedSubview(universityView)
    }
    
    private func configureWebSiteButton() {
        informationStackView.pinToPrevious(30)
        
        informationStackView.addArrangedSubview(webSiteButton)
        webSiteButton.addTarget(self, action: #selector(openWebPage), for: .touchUpInside)
    }
    
    private func configureEmailButton() {
        informationStackView.pinToPrevious(20)
        
        informationStackView.addArrangedSubview(emailButton)
        emailButton.addTarget(self, action: #selector(openMailCompose), for: .touchUpInside)
    }
    
    private func configureProgramLabel() {
        informationStackView.pinToPrevious(20)
        let programsLabel = UILabel()
        programsLabel.text = "Программы"
        programsLabel.font = FontManager.shared.font(for: .tableTitle)
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.distribution = .fill
        
        horizontalStack.addArrangedSubview(programsLabel)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        horizontalStack.addArrangedSubview(spacer)
        
        searchButton.action = { [weak self] in
            self?.router?.routeToSearch()
        }
        searchButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        horizontalStack.addArrangedSubview(searchButton)
        
        informationStackView.addArrangedSubview(horizontalStack)
    }
    
    private func configureFilterSortView() {
        informationStackView.pinToPrevious(13)
        
        informationStackView.addArrangedSubview(filterSortView)
        //        filterSortView.pinRight(to: informationStackView.trailingAnchor)
        filterSortView.pinLeft(to: informationStackView.leadingAnchor)
    }
    
    private func configureSegmentedControl() {
        informationStackView.pinToPrevious(13)
        
        segmentedControl.insertSegment(
            withTitle: "По направлениям",
            at: 0,
            animated: false
        )
        segmentedControl.insertSegment(
            withTitle: "По факультетам",
            at: 1,
            animated: false
        )
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setHeight(35)
        
        let customFont = FontManager.shared.font(for: .commonInformation)
        let customAttributes: [NSAttributedString.Key: Any] = [.font: customFont]
        segmentedControl.setTitleTextAttributes(customAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(customAttributes, for: .selected)
        segmentedControl.addTarget(
            self,
            action: #selector(segmentChanged),
            for: .valueChanged
        )
        
        informationStackView.addArrangedSubview(segmentedControl)
    }
    
    private func configureLastSpace() {
        let spaceView = UIView()
        spaceView.setHeight(17)
        
        informationStackView.addArrangedSubview(spaceView)
    }
    
    func configureRefreshControl() {
        refreshControl.tintColor = .systemCyan
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        tableView.register(
            ProgramTableViewCell.self,
            forCellReuseIdentifier: ProgramTableViewCell.identifier
        )
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "ReusableHeader")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
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
    }
    
    @objc func openWebPage(sender: UIButton) {
        guard let url = URL(string: "https://\(sender.currentTitle ?? "")") else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true, completion: nil)
    }
    
    @objc func segmentChanged() {
        loadPrograms()
    }
}

// MARK: - UniversityDisplayLogic
extension UniversityViewController : UniversityDisplayLogic {
    func displayToggleFavoriteResult(with viewModel: University.Favorite.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(title: "Не удалось добавить ВУЗ в изранные" , with: viewModel.errorMessage)
        }
    }
    
    func displayLoadResult(with viewModel: University.Load.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.webSiteButton.setTitle(viewModel.site, for: .normal)
            self?.emailButton.setTitle(viewModel.email, for: .normal)
        }
    }
}

// MARK: - ProgramsDisplayLogic
extension UniversityViewController : ProgramsDisplayLogic {
    func displayLoadProgramsResult(with viewModel: Programs.Load.ViewModel) {
        groupOfProgramsViewModel = viewModel.groupsOfPrograms
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension UniversityViewController : MFMailComposeViewControllerDelegate{
    @objc func openMailCompose(sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            showAlert(
                with: "На телефоне нет настроенного клиента для отправки электронной почты",
                cancelTitle: "Ок"
            )
            return
        }
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients([sender.currentTitle ?? ""])
        mailVC.setSubject("Вопрос по поступлению")
        mailVC.setMessageBody("Здравствуйте!", isHTML: false)
        
        present(mailVC, animated: true, completion: nil)
    }
    
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension UniversityViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupOfProgramsViewModel.count
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return groupOfProgramsViewModel[section].isExpanded ? groupOfProgramsViewModel[section].programs.count : 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProgramTableViewCell.identifier,
            for: indexPath
        ) as? ProgramTableViewCell else {
            fatalError("Could not dequeue cell")
        }
        
        let fieldViewModel = groupOfProgramsViewModel[indexPath.section].programs[indexPath.row]
        cell.configure(with: fieldViewModel)
        
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        let isLastCell = indexPath.row == totalRows - 1
        
        if isLastCell {
            cell.hideSeparator(true)
        }
        
        cell.favoriteButtonTapped = {[weak self] sender, isFavorite in
            guard let self = self else { return }
            self.groupOfProgramsViewModel[indexPath.section].programs[indexPath.row].like = isFavorite
            let viewModel = self.groupOfProgramsViewModel[indexPath.section].programs[indexPath.row]
            if isFavorite {
                guard
                    let model = self.interactor?.program(at: indexPath)
                else { return }
                FavoritesManager.shared.addProgramToFavorites(university, model)
            } else {
                self.groupOfProgramsViewModel[indexPath.section].programs[indexPath.row].like = false
                FavoritesManager.shared.removeProgramFromFavorites(programID: viewModel.programID)
            }
        }
        
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let headerButton = FieldsTableButton(name: groupOfProgramsViewModel[section].name, code: groupOfProgramsViewModel[section].code)
        headerButton.tag = section
        headerButton.addTarget(self, action: #selector(toggleSection), for: .touchUpInside)
        
        if groupOfProgramsViewModel[section].isExpanded {
            headerButton.backgroundView.backgroundColor = UIColor(hex: "#E0E8FE")
        }
        return headerButton
    }
    
    @objc
    func toggleSection(_ sender: UIButton) {
        let section = sender.tag
        
        var currentOffset = tableView.contentOffset
        let headerRectBefore = tableView.rectForHeader(inSection: section)
        
        groupOfProgramsViewModel[section].isExpanded.toggle()
        
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet(integer: section), with: .none)
            tableView.layoutIfNeeded()
        }
        let headerRectAfter = tableView.rectForHeader(inSection: section)
        
        let deltaY = headerRectAfter.origin.y - headerRectBefore.origin.y
        currentOffset.y += deltaY
        tableView.setContentOffset(currentOffset, animated: false)
    }
    
    @objc private func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            loadPrograms()
            self.refreshControl.endRefreshing()
        }
    }
}

// MARK: - UITableViewDelegate
extension UniversityViewController : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        router?.routeToProgram(with: indexPath)
    }
}

// MARK: - OptionsViewControllerDelegate
extension UniversityViewController: OptionsViewControllerDelegate {
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
extension UniversityViewController: Filterble {
    func deleteFilter(forItemAt index: Int) {
        let item = filterItems[index]
        selectedParams[item.paramType]?.clear()
        loadPrograms()
    }
}

// MARK: - Combine
extension UniversityViewController {
    private func setupUniversityBindings() {
        FavoritesManager.shared.universityEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(let updatedUniversity):
                    if self.university.universityID == updatedUniversity.universityID {
                        self.isFavorite = true
                    }
                case .removed(let universityID):
                    if self.university.universityID == universityID {
                        self.isFavorite = false
                    }
                case .error(let universityID):
                    if self.university.universityID == universityID {
                        self.isFavorite = self.startIsFavorite
                    }
                case .access(let universityID, let isFavorite):
                    if self.university.universityID == universityID {
                        self.startIsFavorite = isFavorite
                    }
                }
                self.reloadFavoriteButton()
            }
            .store(in: &cancellables)
    }
    
    private func setupProgramsBindings() {
        FavoritesManager.shared.programEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .added(_, let program):
                    if let groupIndex = groupOfProgramsViewModel.firstIndex(where: { group in
                        group.programs.contains(where: { $0.programID == program.programID })
                    }) {
                        if let programIndex = groupOfProgramsViewModel[groupIndex].programs.firstIndex(
                            where: {
                                $0.programID == program.programID
                            }) {
                            if groupOfProgramsViewModel[groupIndex].programs[programIndex].like != true {
                                groupOfProgramsViewModel[groupIndex].programs[programIndex].like = true
                                self.tableView.reloadRows(
                                    at: [IndexPath(row: programIndex, section: groupIndex)],
                                    with: .automatic
                                )
                            }
                        }
                    }
                case .removed(let programID):
                    if let groupIndex = groupOfProgramsViewModel.firstIndex(where: { group in
                        group.programs.contains(where: { $0.programID == programID })
                    }) {
                        if let programIndex = groupOfProgramsViewModel[groupIndex].programs.firstIndex(
                            where: {
                                $0.programID == programID
                            }) {
                            if groupOfProgramsViewModel[groupIndex].programs[programIndex].like != false {
                                groupOfProgramsViewModel[groupIndex].programs[programIndex].like = false
                                self.tableView.reloadRows(
                                    at: [IndexPath(row: programIndex, section: groupIndex)],
                                    with: .automatic
                                )
                            }
                        }
                    }
                case .error(let programID):
                    if let groupIndex = groupOfProgramsViewModel.firstIndex(where: { group in
                        group.programs.contains(where: { $0.programID == programID })
                    }) {
                        if let programIndex = groupOfProgramsViewModel[groupIndex].programs.firstIndex(
                            where: {
                                $0.programID == programID
                            }) {
                            groupOfProgramsViewModel[groupIndex].programs[programIndex].like = interactor?.restoreFavorite(at: IndexPath(row: programIndex, section: groupIndex)) ?? false
                            self.tableView.reloadRows(
                                at: [IndexPath(row: programIndex, section: groupIndex)],
                                with: .automatic
                            )
                        }
                    }
                case .access(let programID, let isFavorite):
                    if let groupIndex = groupOfProgramsViewModel.firstIndex(where: { group in
                        group.programs.contains(where: { $0.programID == programID })
                    }) {
                        if let programIndex = groupOfProgramsViewModel[groupIndex].programs.firstIndex(
                            where: {
                                $0.programID == programID
                            }) {
                            
                            let indexPath = IndexPath(row: programIndex, section: groupIndex)
                            
                            interactor?.setFavorite(at: indexPath, isFavorite: isFavorite)
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}
