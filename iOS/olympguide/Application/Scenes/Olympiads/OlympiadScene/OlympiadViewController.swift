//
//  OlympiadViewController.swift
//  olympguide
//
//  Created by Tom Tim on 01.03.2025.
//

import UIKit

final class OlympiadViewController: UIViewController, WithBookMarkButton {
    var inteactor: (OlympiadBusinessLogic & BenefitsByProgramsBusinessLogic)?
    var router: OlympiadRoutingLogic?
    
    private let olympiad: OlympiadModel
    private let informationStackView: UIStackView = UIStackView()
    private let tableView: UITableView = UITableView()
    
    private var universities: [UniversityViewModel] = []
    private var isExpanded: [Bool] = []
    private var programs: [[BenefitsByPrograms.Load.ViewModel.BenefitViewModel]] = []
    
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
        configureUI()
        let request = Olympiad.LoadUniversities.Request(olympiadID: olympiad.olympiadID)
        inteactor?.loadUniversities(with: request)
    }
}

// MARK: - UI Configuration
extension OlympiadViewController {
    private func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationBar()
        
        configureInformatonStack()
        configureOlympiadNameLabel()
        configureOlympiadInformation()
        configureProgramsLabel()
        
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
    
    private func configureOlympiadInformation() {
        let olympiadInformationStack = UIStackView()
        
        olympiadInformationStack.axis = .vertical
        olympiadInformationStack.spacing = 7
        olympiadInformationStack.distribution = .fill
        olympiadInformationStack.alignment = .leading
        
        olympiadInformationStack.addArrangedSubview(configureLevelLabel())
        olympiadInformationStack.addArrangedSubview(configureProfileLabel())
        
        informationStackView.addArrangedSubview(olympiadInformationStack)
    }
    
    private func configureOlympiadNameLabel() {
        let olympiadNameLabel: UILabel = UILabel()
        olympiadNameLabel.font = FontManager.shared.font(for: .commonInformation)
//        olympiadNameLabel.font = FontManager.shared.font(weight: .medium, size: 17.0)
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
//
//        tableView.dataSource = self
//        tableView.delegate = self
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
        let fittingSize = informationStackView.systemLayoutSizeFitting(targetSize)
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
        
        cell.configure(with: programs[indexPath.section][indexPath.row])
        
//        cell.textLabel?.text = programs[indexPath.section][indexPath.row].program.programName
        return cell
    }
}

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
                    section: section
                )
                inteactor?.loadBenefits(with: request)
            } else {
                reloadSectionWithoutAnimation(section)
            }
        }
        return headerView
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    }


extension OlympiadViewController : OlympiadDisplayLogic {
    func displayLoadUniversitiesResult(with viewModel: Olympiad.LoadUniversities.ViewModel) {
        universities = viewModel.universities
        isExpanded = [Bool](repeating: false, count: universities.count)
        programs = [[BenefitsByPrograms.Load.ViewModel.BenefitViewModel]] (repeating: [], count: universities.count)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
}

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
