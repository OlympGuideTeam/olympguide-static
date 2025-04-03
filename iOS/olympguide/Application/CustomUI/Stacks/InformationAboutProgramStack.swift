//
//  InformationAboutProgramStack.swift
//  olympguide
//
//  Created by Tom Tim on 12.03.2025.
//

import UIKit
import SafariServices

final class InformationAboutProgramStack: UIStackView {
    var searchButtonAction: (() -> Void)?
    var link: String?
    
    private let codeLabel: UILabel = UILabel()
    private let programNameLabel: UILabel = UILabel()
    private let webSiteButton: UIInformationButton = UIInformationButton(type: .web)
    private let budgtetLabel: UIInformationLabel = UIInformationLabel()
    private let paidLabel: UIInformationLabel = UIInformationLabel()
    private let costLabel: UIInformationLabel = UIInformationLabel()
    private let subjectsStack: SubjectsStack = SubjectsStack()
    
    private var program: ProgramShortModel?
    private var university: UniversityModel?
    
    private let searchButton: UIClosureButton = {
        let button = UIClosureButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    func configure(
        for program: ProgramShortModel,
        by university: UniversityModel,
        with filterSortView: FilterSortView
    ){
        self.program = program
        self.university = university
        configureUI(filterSortView)
    }
    
    func configure(
        name: String,
        code: String,
        university: UniversityModel,
        filterSortView: FilterSortView
    ) {
        self.university = university
        programNameLabel.text = name
        codeLabel.text = code
        configureUI(filterSortView)
    }
    
    func configureUI(_ filterSortView: FilterSortView) {
        setupSelf()
        configureUniversityView()
        configureCodeLabel()
        configureProgramNameLabel()
        configureWebButton()
        configureBudgetLabel()
        configurePaidLabel()
        configureCostLabel()
        configureSubjectsStack()
        configureBenefitsLabel()
        configureLastSpace()
        configureFilterSortView(filterSortView)
    }
    
    private func setupSelf() {
        arrangedSubviews.forEach { removeArrangedSubview($0) }
        axis = .vertical
        alignment = .fill
        distribution = .fill
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 20)
    }
    
    private func configureUniversityView() {
        guard let university = university else { return }
        let universityView = UIUniversityView()
        universityView.configure(with: university.toViewModel(), 20, 20)
        universityView.favoriteButtonIsHidden = true
        
        addArrangedSubview(universityView)
    }
    
    private func configureCodeLabel() {
        pinToPrevious(30)
        
        codeLabel.font = FontManager.shared.font(for: .additionalInformation)
        if let code = program?.field {
            codeLabel.text = code
        }
        
        codeLabel.calculateHeight()
        addArrangedSubview(codeLabel)
    }
    
    private func configureProgramNameLabel() {
        pinToPrevious(5)
        
        programNameLabel.font = FontManager.shared.font(for: .commonInformation)
        programNameLabel.numberOfLines = 0
        programNameLabel.lineBreakMode = .byWordWrapping
        
        if let name = program?.name {
            programNameLabel.text = name
        }

        addArrangedSubview(programNameLabel)
    }
    
    private func configureWebButton() {
        pinToPrevious(5)
        addArrangedSubview(webSiteButton)
        
        if var link = program?.link {
            link = link.replacingOccurrences(of: "https://www.", with: "")
                .replacingOccurrences(of: "https://", with: "")
            
            webSiteButton.setTitle(link, for: .normal)
        }
        
        webSiteButton.addTarget(self, action: #selector(openWebPage), for: .touchUpInside)
    }
    
    private func configureBudgetLabel() {
        pinToPrevious(11)
        
        budgtetLabel.setText(regular: "Бюджетных мест  ")
        if let budgetPlaced = program?.budgetPlaces {
            budgtetLabel.setBoldText(String(budgetPlaced))
        }
        
        addArrangedSubview(budgtetLabel)
    }
    
    private func configurePaidLabel() {
        pinToPrevious(7)
        
        paidLabel.setText(regular: "Платных мест  ")
        if let paidPlaces = program?.paidPlaces {
            paidLabel.setBoldText(String(paidPlaces))
        }
        
        addArrangedSubview(paidLabel)
    }
    
    private func configureCostLabel() {
        pinToPrevious(7)
        
        costLabel.setText(regular: "Стоимость  ")
        if let cost = program?.cost {
            costLabel.setBoldText(formatNumber(cost))
        }
        
        addArrangedSubview(costLabel)
    }
    
    func formatNumber(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return "\(formatter.string(from: NSNumber(value: number)) ?? "\(number)") ₽/год"
    }
    
    private func configureSubjectsStack() {
        pinToPrevious(11)
        
        if
            let requiredSubjects = program?.requiredSubjects,
            let optionalSubjects = program?.optionalSubjects {
            subjectsStack.configure(
                requiredSubjects: requiredSubjects,
                optionalSubjects: optionalSubjects
            )
            let spacer = UIView()
            spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
            subjectsStack.addArrangedSubview(spacer)
        }
        
        addArrangedSubview(subjectsStack)
    }
    
    private func configureBenefitsLabel() {
        pinToPrevious(20)
        let benefitsLabel = UILabel()
        benefitsLabel.text = "Льготы"
        benefitsLabel.font = FontManager.shared.font(for: .tableTitle)
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.distribution = .fill
        
        horizontalStack.addArrangedSubview(benefitsLabel)
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        horizontalStack.addArrangedSubview(spacer)
        
        searchButton.action = { [weak self] in
            self?.searchButtonAction?()
        }
        
        searchButton.setWidth(28)
        searchButton.setHeight(28)
        
        horizontalStack.addArrangedSubview(searchButton)
        
        addArrangedSubview(horizontalStack)
    }
    
    private func configureFilterSortView(_ filterSortView: FilterSortView) {
//        pinToPrevious(13)
        
        addSubview(filterSortView)
        filterSortView.pinLeft(to: leadingAnchor)
        filterSortView.pinRight(to: trailingAnchor)
        filterSortView.pinBottom(to: bottomAnchor)
    }
    
    private func configureLastSpace() {
        let spaceView = UIView()
        spaceView.setHeight(31 + 13)
        
        addArrangedSubview(spaceView)
    }
    
    func setInformation(_ program: ProgramShortModel) {
        let link = program.link
            .replacingOccurrences(of: "https://www.", with: "")
            .replacingOccurrences(of: "https://", with: "")
        webSiteButton.setTitle(link, for: .normal)
        budgtetLabel.setBoldText(String(program.budgetPlaces))
        paidLabel.setBoldText(String(program.paidPlaces))
        costLabel.setBoldText(formatNumber(program.cost))
        subjectsStack.configure(
            requiredSubjects: program.requiredSubjects,
            optionalSubjects: program.optionalSubjects ?? []
        )
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        subjectsStack.addArrangedSubview(spacer)
    }
    
    @objc func openWebPage(sender: UIButton) {
        guard
            let currentVC = self.findViewController(),
            let link = sender.currentTitle
        else { return }
        
        guard let url = URL(string: "https://\(link)") else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        currentVC.present(safariVC, animated: true, completion: nil)
    }
}
