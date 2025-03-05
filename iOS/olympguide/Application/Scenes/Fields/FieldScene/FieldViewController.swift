//
//  FieldViewController.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit

final class FieldViewController: UIViewController {
    private let field: GroupOfFieldsModel.FieldModel
    
    private let informationStackView: UIStackView = UIStackView()
    private let tableView: UITableView = UITableView()
    
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
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        configureInformationStackView()
        configureNameLabel()
        configureDegreeLabel()
        configureProgramsTitleLabel()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        title = field.code
        let backItem = UIBarButtonItem(title: field.code, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
    }
    
    private func configureInformationStackView() {
        view.addSubview(informationStackView)
        informationStackView.axis = .vertical
        informationStackView.spacing = 17
        informationStackView.distribution = .fill
        informationStackView.alignment = .leading
        
        informationStackView.isLayoutMarginsRelativeArrangement = true
        informationStackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 0, right: 20)
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

//extension FieldViewController : UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//    
//    
//}

