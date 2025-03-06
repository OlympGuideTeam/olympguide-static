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
    var interactor: (ProgramBusinessLogic & BenefitsByOlympiadsBusinessLogic)?
    var router: (ProgramRoutingLogic & BenefitsByOlympiadsRoutingLogic)?
    
    private var cancellables = Set<AnyCancellable>()
    
    let programId: Int
    let logoImageView: UIImageViewWithShimmer = UIImageViewWithShimmer(frame: .zero)
    var startIsFavorite: Bool?
    var isFavorite: Bool?
    let universityNameLabel: UILabel = UILabel()
    let regionLabel: UILabel = UILabel()
    let university: UniversityModel
    let codeLabel: UILabel = UILabel()
    let programNameLabel = UILabel()
    var program: ProgramShortModel?
    var benefits: [OlympiadWithBenefitViewModel] = []
    var link: String? = nil
    
    private let informationContainer: UIView = UIView()
    private let budgtetLabel: UIInformationLabel = UIInformationLabel()
    private let paidLabel: UIInformationLabel = UIInformationLabel()
    private let costLabel: UIInformationLabel = UIInformationLabel()
    private let subjectsStack: SubjectsStack = SubjectsStack()
    private let webSiteButton: UIInformationButton = UIInformationButton(type: .web)
    
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    init(
        for programID: Int,
        name: String,
        code: String,
        university: UniversityModel
    ) {
        self.university = university
        self.programId = programID
        self.programNameLabel.text = name
        self.codeLabel.text = code
        super.init(nibName: nil, bundle: nil)
    }
    
    init (
        for program: ProgramModel
    ) {
        self.isFavorite = program.like
        self.startIsFavorite = program.like
        self.programId = program.programID
        self.university = program.university
        self.program = ProgramShortModel(
            programID: program.programID,
            name: program.name,
            field: program.field,
            budgetPlaces: program.budgetPlaces,
            paidPlaces: program.paidPlaces,
            cost: program.cost,
            requiredSubjects: program.requiredSubjects,
            optionalSubjects: program.optionalSubjects,
            like: program.like,
            link: program.link ?? ""
        )
        
        if var link = program.link {
            link = link.replacingOccurrences(of: "https://www.", with: "")
                .replacingOccurrences(of: "https://", with: "")
            self.webSiteButton.setTitle(link, for: .normal)
            self.link = link
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(
        for program: ProgramShortModel,
        by university: UniversityModel
    ) {
        self.isFavorite = program.like
        self.startIsFavorite = program.like
        self.university = university
        self.program = program
        self.programId = program.programID
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupBindings()
        
        ImageLoader.shared.loadImage(from: university.logo) { [weak self] (image: UIImage?) in
            guard let self = self, let image = image else { return }
            self.logoImageView.stopShimmer()
            self.logoImageView.image = image
        }
        
        let benefitRequest = BenefitsByOlympiads.Load.Request(programID: programId)
        interactor?.loadOlympiads(with: benefitRequest)
        
        if webSiteButton.titleLabel?.text == nil {
            let programRequest = Program.Load.Request(programID: programId)
            interactor?.loadProgram(with: programRequest)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureFavoriteButton()
        
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

        let newImageName = isFavorite ? "bookmark.fill" :  "bookmark"
        navigationController.bookMarkButton.setImage(UIImage(systemName: newImageName), for: .normal)
        navigationController.bookMarkButtonPressed = {[weak self] sender in
            guard
                let self = self,
                var isFavorite = self.isFavorite,
                let program = self.program
            else { return }
            isFavorite.toggle()
            // TODO: -
//            self?.isFavorite.toggle()
            let newImageName = self.isFavorite ?? false ? "bookmark.fill" :  "bookmark"
            sender.setImage(UIImage(systemName: newImageName), for: .normal)
            
            
            if isFavorite {
                let model = ProgramModel(
                    programID: program.programID,
                    name: program.name,
                    field: program.field,
                    budgetPlaces: program.budgetPlaces,
                    paidPlaces: program.paidPlaces,
                    cost: program.cost,
                    requiredSubjects: program.requiredSubjects,
                    optionalSubjects: program.optionalSubjects ?? [],
                    like: true,
                    university: university,
                    link: self.link
                )
                
                FavoritesManager.shared.addProgramToFavorites(viewModel: model)
            } else {
                FavoritesManager.shared.removeProgramFromFavorites(programID: program.programID)
            }
        }
    }
}

// MARK: - UI Configuration
extension ProgramViewController {
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureLogoImageView()
        configureRegionLabel()
        configureUniversityNameLabel()
        configureCodeLabel()
        configureProgramNameLabel()
        configureWebButton()
        configureBudgetLabel()
        configurePaidLabel()
        configureCostLabel()
        configureSubjectsStack()
        configureBenefitsLabel()
        
        configureRefreshControl()
        configureTableView()
        
        reloadFavoriteButton()
        
        logoImageView.startShimmer()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        let backItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    private func configureLogoImageView() {
        informationContainer.addSubview(logoImageView)
        
        logoImageView.contentMode = .scaleAspectFit
        
        logoImageView.pinLeft(to: informationContainer.leadingAnchor, Constants.Dimensions.logoLeftMargin)
        logoImageView.pinTop(to: informationContainer.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.logoTopMargin)
        logoImageView.setWidth(Constants.Dimensions.logoSize)
        logoImageView.setHeight(Constants.Dimensions.logoSize)
    }
    
    private func configureRegionLabel() {
        regionLabel.font = Constants.Fonts.regionLabelFont
        regionLabel.textColor = Constants.Colors.regionTextColor
        regionLabel.text = university.region
        
        informationContainer.addSubview(regionLabel)
        
        regionLabel.pinTop(to: informationContainer.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.logoTopMargin)
        regionLabel.pinLeft(to: logoImageView.trailingAnchor, Constants.Dimensions.interItemSpacing)
    }
    
    private func configureUniversityNameLabel() {
        universityNameLabel.font = Constants.Fonts.nameLabelFont
        universityNameLabel.numberOfLines = 0
        universityNameLabel.lineBreakMode = .byWordWrapping
        universityNameLabel.text = university.name
        
        informationContainer.addSubview(universityNameLabel)

        universityNameLabel.pinTop(to: regionLabel.bottomAnchor, 5)
        universityNameLabel.pinLeft(to: logoImageView.trailingAnchor, Constants.Dimensions.interItemSpacing)
        universityNameLabel.pinRight(to: informationContainer.trailingAnchor, Constants.Dimensions.interItemSpacing)
        universityNameLabel.calculateHeight(with: view.frame.width - 15 - 15 - 80 - 15)
    }
    
    private func configureCodeLabel() {
        codeLabel.font = FontManager.shared.font(for: .additionalInformation)
        if codeLabel.text?.isEmpty ?? true {
            codeLabel.text = program?.field ?? ""
        }
        
        informationContainer.addSubview(codeLabel)
        codeLabel.pinTop(to: logoImageView.bottomAnchor, 30)
//        codeLabel.pinTop(to: universityNameLabel.bottomAnchor, 30, .grOE)
        codeLabel.pinLeft(to: informationContainer.leadingAnchor, 20)
        codeLabel.calculateHeight(with: view.frame.width - 40)
    }
    
    private func configureProgramNameLabel() {
        programNameLabel.font = FontManager.shared.font(for: .commonInformation)
        programNameLabel.numberOfLines = 0
        programNameLabel.lineBreakMode = .byWordWrapping
        if programNameLabel.text?.isEmpty ?? true {
            programNameLabel.text = program?.name ?? ""
        }
        
        informationContainer.addSubview(programNameLabel)
        programNameLabel.pinTop(to: codeLabel.bottomAnchor, 5)
        programNameLabel.pinLeft(to: informationContainer.leadingAnchor, 20)
        programNameLabel.pinRight(to: informationContainer.trailingAnchor, 20)
        programNameLabel.calculateHeight(with: view.frame.width - 40)
    }
    
    private func configureWebButton() {
        informationContainer.addSubview(webSiteButton)
        
        webSiteButton.pinTop(to: programNameLabel.bottomAnchor, 5)
        webSiteButton.pinLeft(to: informationContainer.leadingAnchor, 20)
        webSiteButton.pinRight(to: informationContainer.trailingAnchor, 20)
        
        webSiteButton.addTarget(self, action: #selector(openWebPage), for: .touchUpInside)
    }
    
    private func configureBudgetLabel() {
        budgtetLabel.setText(regular: "Бюджетных мест  ")
        if let budgetPlaced = program?.budgetPlaces {
            budgtetLabel.setBoldText(String(budgetPlaced))
        }
        
        informationContainer.addSubview(budgtetLabel)
        
        budgtetLabel.pinTop(to: webSiteButton.bottomAnchor, 11)
        budgtetLabel.pinLeft(to: informationContainer.leadingAnchor, 20)
    }
    
    private func configurePaidLabel() {
        paidLabel.setText(regular: "Платных мест  ")
        if let paidPlaces = program?.paidPlaces {
            paidLabel.setBoldText(String(paidPlaces))
        }
        
        informationContainer.addSubview(paidLabel)
        
        paidLabel.pinTop(to: budgtetLabel.bottomAnchor, 7)
        paidLabel.pinLeft(to: informationContainer.leadingAnchor, 20)
    }
    
    private func configureCostLabel() {
        costLabel.setText(regular: "Стоимость  ")
        if let cost = program?.cost {
            costLabel.setBoldText(formatNumber(cost))
        }
        
        informationContainer.addSubview(costLabel)
        
        costLabel.pinTop(to: paidLabel.bottomAnchor, 7)
        costLabel.pinLeft(to: informationContainer.leadingAnchor, 20)
    }
    
    private func configureSubjectsStack() {
        if
            let requiredSubjects = program?.requiredSubjects,
            let optionalSubjects = program?.optionalSubjects {
            subjectsStack.configure(
                requiredSubjects: requiredSubjects,
                optionalSubjects: optionalSubjects
            )
        }
        informationContainer.addSubview(subjectsStack)
        
        subjectsStack.pinTop(to: costLabel.bottomAnchor, 11)
        subjectsStack.pinLeft(to: informationContainer.leadingAnchor, 20)
    }
    
    func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return "\(formatter.string(from: NSNumber(value: number)) ?? "\(number)") ₽/год"
    }
    
    private func configureBenefitsLabel() {
        let benefitsLabel = UILabel()
        benefitsLabel.text = "Льготы"
        benefitsLabel.font = FontManager.shared.font(for: .tableTitle)
        
        informationContainer.addSubview(benefitsLabel)
        benefitsLabel.pinTop(to: subjectsStack.bottomAnchor, 20)
        benefitsLabel.pinLeft(to: informationContainer.leadingAnchor, 20)
        benefitsLabel.pinBottom(to: informationContainer.bottomAnchor)
        
        //        let textSize = text.size(withAttributes: [.font: font])
        //
        //        programsLabel.setHeight(textSize.height)
    }
    
    func configureRefreshControl() {
        refreshControl.tintColor = .systemCyan
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        tableView.register(
            OlympiadTableViewCell.self,
            forCellReuseIdentifier: OlympiadTableViewCell.identifier
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        
        informationContainer.setNeedsLayout()
        informationContainer.layoutIfNeeded()
        
        let targetSize = CGSize(
            width: tableView.bounds.width,
            height: UIView.layoutFittingCompressedSize.height
        )
        let fittingSize = informationContainer.systemLayoutSizeFitting(targetSize)
        informationContainer.frame.size.height = fittingSize.height
        tableView.tableHeaderView = informationContainer
        
        tableView.tableHeaderView = informationContainer
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
            guard let programID = self?.programId else { return }
            let request = BenefitsByOlympiads.Load.Request(programID: programID)
            
            self?.interactor?.loadOlympiads(with: request)
            self?.refreshControl.endRefreshing()
        }
    }
    
    @objc func openWebPage(sender: UIButton) {
        guard let contact = sender.currentTitle else { return }
        let realContact = contact.replacingOccurrences(of: "@", with: "")
        guard let url = URL(string: "https://\(realContact)") else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension ProgramViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        benefits.count != 0 ? benefits.count : 10
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: OlympiadTableViewCell.identifier,
            for: indexPath
        ) as? OlympiadTableViewCell
        else {
            return UITableViewCell()
        }
        
        if benefits.count != 0 {
            let benefitModel = benefits[indexPath.row]
            cell.configure(with: benefitModel)
        } else {
            cell.configureShimmer()
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProgramViewController : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = BenefitViewController(with: benefits[indexPath.row])
        detailVC.modalPresentationStyle = .pageSheet
        if let sheet = detailVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
        }
        present(detailVC, animated: true)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(
      _ tableView: UITableView,
      contextMenuConfigurationForRowAt indexPath: IndexPath,
      point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                let detailVC = BenefitViewController(with: self.benefits[indexPath.row])
                return detailVC
            },
            actionProvider: { _ in
                return UIMenu(title: "", children: [
                ])
            }
        )
    }
}

// MARK: - BenefitsDisplayLogic
extension ProgramViewController : BenefitsByOlympiadsDisplayLogic {
    func displayLoadOlympiadsResult(with viewModel: BenefitsByOlympiads.Load.ViewModel) {
        benefits = viewModel.benefits
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
        webSiteButton.setTitle(link, for: .normal)
        self.link = link
        program = viewModel.program
        startIsFavorite = viewModel.program.like
        isFavorite = startIsFavorite
        budgtetLabel.setBoldText(String(viewModel.program.budgetPlaces))
        paidLabel.setBoldText(String(viewModel.program.paidPlaces))
        costLabel.setBoldText(formatNumber(viewModel.program.cost))
        subjectsStack.configure(
            requiredSubjects: viewModel.program.requiredSubjects,
            optionalSubjects: viewModel.program.optionalSubjects ?? []
        )
        configureFavoriteButton()
    }
    
    func displayToggleFavoriteResult(viewModel: Program.Favorite.ViewModel) {
        
    }
}

// MARK: - Combine
extension ProgramViewController {
    private func setupBindings() {
        FavoritesManager.shared.programEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case.added(let program):
                    if program.programID == self.programId {
                        self.isFavorite = true
                    }
                case .removed(let programID):
                    if programID == self.programId {
                        self.isFavorite = false
                    }
                case .error(let programID):
                    if programID == self.programId {
                        self.isFavorite = self.startIsFavorite
                    }
                case .access(let programID, let isFavorite):
                    if programID == self.programId {
                        self.startIsFavorite = isFavorite
                    }
                }
                reloadFavoriteButton()
            }.store(in: &cancellables)
    }
    
    private func reloadFavoriteButton() {
        guard let isFavorite = self.isFavorite else { return }
        guard let navigationController = navigationController as? NavigationBarViewController else { return }
        let newImageName = isFavorite ? "bookmark.fill" :  "bookmark"
        navigationController.bookMarkButton.setImage(UIImage(systemName: newImageName), for: .normal)
    }
}


