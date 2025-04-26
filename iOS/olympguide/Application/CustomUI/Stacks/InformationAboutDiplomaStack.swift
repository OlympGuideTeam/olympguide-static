//
//  InformationAboutDiplomaStack.swift
//  olympguide
//
//  Created by Vladislav Pankratov on 26.04.2025.
//

import UIKit

final class InformationAboutDiplomaStack: UIStackView {
    typealias Constants = AllConstants.InformationAboutOlympStack
    typealias Common = AllConstants.Common

    private var diploma: DiplomaModel?
    var searchButtonAction: (() -> Void)?
    
    let searchButton: UIClosureButton = {
        let button = UIClosureButton()
        button.setImage(Common.Images.search, for: .normal)
        button.tintColor = Common.Colors.text
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    func configure(
        _ diploma: DiplomaModel,
        _ filterSortView: FilterSortView
    ) {
        self.diploma = diploma
        
        setupSelf()
        configureDiplomaNameLabel()
        configureOlympiadInformation()
        configureProgramsLabel()
        configureFilterSortView(filterSortView)
    }
    
    
    private func setupSelf() {
        arrangedSubviews.forEach { removeArrangedSubview($0) }
        axis = .vertical
        spacing = Constants.Dimensions.stackSpacing
        distribution = .fill
        alignment = .leading
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(
            top: Constants.Dimensions.layoutMarginTop,
            left: Constants.Dimensions.layoutMarginHorizontal,
            bottom: Constants.Dimensions.layoutMarginBottom,
            right: Constants.Dimensions.layoutMarginHorizontal
        )
    }
    
    private func configureDiplomaNameLabel() {
        guard let diploma = self.diploma else { return }
        let diplomaNameLabel = UILabel()
        diplomaNameLabel.font = FontManager.shared.font(weight: .medium, size: 17.0)
        diplomaNameLabel.numberOfLines = 0
        diplomaNameLabel.lineBreakMode = .byWordWrapping
        diplomaNameLabel.text = diploma.olympiad.name
        
        diplomaNameLabel.calculateHeight()
        addArrangedSubview(diplomaNameLabel)
    }
    
    private func configureOlympiadInformation() {
        let olympiadInformationStack = UIStackView()
        
        olympiadInformationStack.axis = .vertical
        olympiadInformationStack.spacing = Constants.Dimensions.olympiadInfoSpacing
        olympiadInformationStack.distribution = .fill
        olympiadInformationStack.alignment = .fill
        
        olympiadInformationStack.addArrangedSubview(configureLevelLabel())
        olympiadInformationStack.addArrangedSubview(configureProfileLabel())
        olympiadInformationStack.addArrangedSubview(configureDiplomaLevel())
        olympiadInformationStack.addArrangedSubview(configureDiplomaClassLabel())
        
        addArrangedSubview(olympiadInformationStack)
    }
    
    private func configureLevelLabel() -> UILabel {
        guard let diploma = self.diploma else { return UILabel() }
        let levelLabel = UILabel()
        levelLabel.font = FontManager.shared.font(for: .additionalInformation)
        levelLabel.textColor = Constants.Colors.additionalText
        levelLabel.text = Constants.Strings.levelPrefix + String(repeating: "I", count: diploma.olympiad.level)
        
        return levelLabel
    }
    
    private func configureProfileLabel() -> UILabel {
        guard let olympiad = self.diploma?.olympiad else { return UILabel() }
        let profileLabel = UILabel()
        profileLabel.font = FontManager.shared.font(for: .additionalInformation)
        profileLabel.textColor = Constants.Colors.additionalText
        profileLabel.numberOfLines = 0
        profileLabel.lineBreakMode = .byWordWrapping
        profileLabel.text = Constants.Strings.profilePrefix + olympiad.profile
        profileLabel.calculateHeight()
        return profileLabel
    }
    
    private func configureProgramsLabel() {
        let programsLabel = UILabel()
        
        programsLabel.font = FontManager.shared.font(for: .tableTitle)
        programsLabel.textColor = Constants.Colors.text
        programsLabel.text = Constants.Strings.programsTitle
        addArrangedSubview(programsLabel)
        
        let searchButton = getSearchButton()
        searchButton.action = { [weak self] in
            self?.searchButtonAction?()
        }
        addSubview(searchButton)
        searchButton.pinRight(to: trailingAnchor, Constants.Dimensions.layoutMarginHorizontal)
        searchButton.pinCenterY(to: programsLabel)
    }
    
    private func configureDiplomaLevel() -> UILabel {
        guard let diploma = self.diploma else { return UILabel() }
        let diplomaLevelLabel = UILabel()
        diplomaLevelLabel.font = FontManager.shared.font(for: .additionalInformation)
        diplomaLevelLabel.textColor = Constants.Colors.additionalText
        diplomaLevelLabel.numberOfLines = 0
        diplomaLevelLabel.lineBreakMode = .byWordWrapping
        let diplomaLevel = diploma.level == 1 ? "победитель" : "призёр"
        diplomaLevelLabel.text = "Степень диплома: " + diplomaLevel
        diplomaLevelLabel.calculateHeight()
        return diplomaLevelLabel
    }
    
    private func configureDiplomaClassLabel() -> UILabel {
        guard let diploma = self.diploma else { return UILabel() }
        let diplomaClassLabel = UILabel()
        diplomaClassLabel.font = FontManager.shared.font(for: .additionalInformation)
        diplomaClassLabel.textColor = Constants.Colors.additionalText
        diplomaClassLabel.numberOfLines = 0
        diplomaClassLabel.lineBreakMode = .byWordWrapping
        diplomaClassLabel.text = "Степень диплома: " + diploma.diplomaClass.description
        diplomaClassLabel.calculateHeight()
        return diplomaClassLabel
    }
    
    private func getSearchButton() -> UIClosureButton {
        searchButton.isEnabled = false
        searchButton.setWidth(Constants.Dimensions.searchButtonSize)
        searchButton.setHeight(Constants.Dimensions.searchButtonSize)
        return searchButton
    }
    
    private func configureFilterSortView(_ filterSortView: FilterSortView) {
        pinToPrevious(Constants.Dimensions.pinToPreviousOffset)
        addArrangedSubview(UIView())
        
        addSubview(filterSortView)
        filterSortView.pinLeft(to: leadingAnchor)
        filterSortView.pinRight(to: trailingAnchor)
        filterSortView.pinBottom(to: bottomAnchor, Constants.Dimensions.pinBottomOffset)
    }
}

