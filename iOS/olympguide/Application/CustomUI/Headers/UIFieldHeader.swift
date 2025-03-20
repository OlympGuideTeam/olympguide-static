//
//  UIFieldHeader.swift
//  olympguide
//
//  Created by Tom Tim on 11.03.2025.
//

import UIKit

final class UIFieldHeaderCell : UITableViewCell {
    typealias Constants = AllConstants.UIFieldHeaderCell
    typealias Common = AllConstants.Common
    
    static let identifier = "UIFieldHeaderCell"
    
    var toggleSection: ((_: Int) -> Void)?
    
    private let fieldStackView: UIStackView = UIStackView()
    private let background: UIView = UIView()
    private let arrowImageView: UIImageView = UIImageView()
    
    private var isExpanded: Bool = false
    
    // MARK: - Lifecycle
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayouts()
        selectionStyle = .none
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayouts() {
        backgroundColor = .white
        configureBackgroundView()
        configureFieldStackView()
        configureArrowImageView()
    }
    
    private func configureBackgroundView() {
        contentView.addSubview(background)
        
        background.isUserInteractionEnabled = false
        
        background.backgroundColor = .white
        background.layer.cornerRadius = Constants.Dimensions.backroundRadius
        background.pinTop(to: contentView.topAnchor)
        background.pinBottom(to: contentView.bottomAnchor)
        background.pinLeft(to: contentView.leadingAnchor, Constants.Dimensions.backgroundVerticalMargin)
        background.pinRight(to: contentView.trailingAnchor, Constants.Dimensions.backgroundVerticalMargin)
        background.backgroundColor = Common.Colors.accient
    }
    
    private func configureFieldStackView() {
        contentView.addSubview(fieldStackView)
        fieldStackView.pinTop(to: contentView.topAnchor, Constants.Dimensions.fieldStackVerticalMargin)
        fieldStackView.pinLeft(to: contentView.leadingAnchor, Constants.Dimensions.leftMargin)
        fieldStackView.pinBottom(to: contentView.bottomAnchor, Constants.Dimensions.fieldStackVerticalMargin)
        fieldStackView.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
    }
    
    private func configureArrowImageView() {
        contentView.addSubview(arrowImageView)
        
        arrowImageView.isUserInteractionEnabled = false
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = .black
        arrowImageView.setWidth(Constants.Dimensions.arrowSize)
        
        arrowImageView.pinTop(to: contentView.topAnchor, Constants.Dimensions.arrowTopMargin)
        arrowImageView.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
    }
    
    private func updateApperance() {
        arrowImageView.image = isExpanded
        ? Common.Images.openedSection
        : Common.Images.closedSection
        
        background.backgroundColor = isExpanded
        ? Common.Colors.accient
        : .clear
    }
    
    func configure(
        with field: FieldViewModel,
        isExpanded: Bool = false
    ) {
        self.isExpanded = isExpanded
        let capitalizeName = capitalizeFirstLetter(field.name)
        
        fieldStackView.configure(
            with: field.code,
            and: capitalizeName,
            width: nil
        )
        
        updateApperance()
    }
    
    private func capitalizeFirstLetter(_ input: String) -> String {
        guard let firstChar = input.first else { return "" }
        return firstChar.uppercased() + input.dropFirst().lowercased()
    }
}
