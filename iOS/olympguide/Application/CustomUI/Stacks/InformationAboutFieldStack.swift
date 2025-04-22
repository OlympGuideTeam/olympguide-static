//
//  InformationAboutFieldStack.swift
//  olympguide
//
//  Created by Tom Tim on 13.03.2025.
//

import UIKit

final class InformationAboutFieldStack : UIStackView {
    typealias Constants = AllConstants.InformationAboutFieldStack
    typealias Dimensions = Constants.Dimensions
    typealias Strings = Constants.Strings
    typealias Common = AllConstants.Common
    
    var searchTapped: (() -> Void)?
    
    func configure(
        with field: GroupOfFieldsModel.FieldModel
    ) {
        setupSelf()
        configureNameLabel(field)
        configureDegreeLabel(field)
        configureProgramsTitleLabel()
    }
    
    private func setupSelf() {
        arrangedSubviews.forEach { removeArrangedSubview($0) }
        axis = .vertical
        alignment = .fill
        distribution = .fill
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(
            top: Dimensions.nameTopMargin,
            left: Common.Dimensions.horizontalMargin,
            bottom: Dimensions.progrmmsTitleBottomMargin,
            right: Common.Dimensions.horizontalMargin
        )
    }
    
    private func configureNameLabel(_ field: GroupOfFieldsModel.FieldModel) {
        let nameLabel = UILabel()
        nameLabel.textColor = .black
        nameLabel.font = FontManager.shared.font(
            weight: .medium,
            size: Dimensions.nameFontSize
        )
        nameLabel.text = field.name
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.calculateHeight()
        addArrangedSubview(nameLabel)
    }
    
    private func configureDegreeLabel(_ field: GroupOfFieldsModel.FieldModel) {
        pinToPrevious(Dimensions.itemsSpacing)
        let degreeLabel = UILabel()
        degreeLabel.textColor = .black
        degreeLabel.font = FontManager.shared.font(for: .additionalInformation)
        degreeLabel.text = "\(Strings.degreeText)\(field.degree)"
        degreeLabel.calculateHeight()
        addArrangedSubview(degreeLabel)
    }
    
    private func configureProgramsTitleLabel() {
        pinToPrevious(Dimensions.itemsSpacing)
        let programsTitleLabel: UILabel = UILabel()
        programsTitleLabel.text = Strings.programsText
        programsTitleLabel.font = FontManager.shared.font(for: .tableTitle)
        programsTitleLabel.textColor = .black
        programsTitleLabel.calculateHeight()
        addArrangedSubview(programsTitleLabel)
        
        let searchButton = getSearchButton()
        
        searchButton.action = { [weak self] in
            self?.searchTapped?()
        }
        addSubview(searchButton)
        searchButton.pinRight(to: trailingAnchor, Common.Dimensions.horizontalMargin)
        searchButton.pinCenterY(to: programsTitleLabel)
    }
    
    private func getSearchButton() -> UIClosureButton {
        let searchButton = UIClosureButton()
        searchButton.setImage(Common.Images.search, for: .normal)
        searchButton.tintColor = .black
        searchButton.contentHorizontalAlignment = .fill
        searchButton.contentVerticalAlignment = .fill
        searchButton.imageView?.contentMode = .scaleAspectFit
        
        
        searchButton.setWidth(Common.Dimensions.searchButtonSize)
        searchButton.setHeight(Common.Dimensions.searchButtonSize)
        
        return searchButton
    }
}
