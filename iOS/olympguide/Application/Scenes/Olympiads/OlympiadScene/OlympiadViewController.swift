//
//  OlympiadViewController.swift
//  olympguide
//
//  Created by Tom Tim on 01.03.2025.
//

import UIKit

final class OlympiadViewController: UIViewController, WithBookMarkButton {
    private let olympiad: OlympiadModel
    private let informationStackView: UIStackView = UIStackView()
    private let tableView: UITableView = UITableView()
    
    private var benefits: [BenefitsByPrograms.Load.ViewModel.BenefitViewModel] = []
    
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
        informationStackView.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 20)
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
        olympiadNameLabel.font = FontManager.shared.font(for: .additionalInformation)
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
            OlympiadTableViewCell.self,
            forCellReuseIdentifier: OlympiadTableViewCell.identifier
        )
//
//        tableView.dataSource = self
//        tableView.delegate = self
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
    }
}

// MARK: - UITableViewDataSource
//extension OlympiadViewController : UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        benefits.count != 0 ? benefits.count : 10
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//    }
//}
