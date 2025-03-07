//
//  FieldViewController.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit

final class FieldViewController: UIViewController {
    var interactor: FieldBusinessLogic?
    var router: FieldRoutingLogic?
    
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
        
        configureUI()
        let request = Field.LoadPrograms.Request(fieldID: field.fieldId)
        interactor?.loadPrograms(with: request)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureInformationStackView()
        configureNameLabel()
        configureDegreeLabel()
        configureProgramsTitleLabel()
        configureRefreshControl()
        configureTableView()
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
        view.addSubview(informationStackView)
        informationStackView.axis = .vertical
        informationStackView.spacing = 17
        informationStackView.distribution = .fill
        informationStackView.alignment = .leading
        
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
        let degreeLabel = UILabel()
        degreeLabel.textColor = .black
        degreeLabel.font = FontManager.shared.font(for: .additionalInformation)
        degreeLabel.text = "Степень: \(field.degree)"
        
        informationStackView.addArrangedSubview(degreeLabel)
    }
    
    private func configureProgramsTitleLabel() {
        let programsTitleLabel: UILabel = UILabel()
        programsTitleLabel.text = "Программы"
        programsTitleLabel.font = FontManager.shared.font(for: .tableTitle)
        programsTitleLabel.textColor = .black
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
    
    func configureRefreshControl() {
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
        let fittingSize = informationStackView.systemLayoutSizeFitting(targetSize)
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
            let request = Field.LoadPrograms.Request(fieldID: self.field.fieldId)
            self.interactor?.loadPrograms(with: request)
            self.refreshControl.endRefreshing()
        }
    }
}


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
        return cell
    }
}

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

extension FieldViewController : FieldDisplayLogic {
    func displayLoadProgramsResult(with viewModel: Field.LoadPrograms.ViewModel) {
        programs = viewModel.programs
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
}
