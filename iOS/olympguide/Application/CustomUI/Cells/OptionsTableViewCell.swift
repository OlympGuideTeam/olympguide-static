//
//  ChoiceCell.swift
//  olympguide
//
//  Created by Tom Tim on 27.12.2024.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {
    typealias Constants = AllConstants.OptionsTableViewCell
    typealias Common = AllConstants.Common
    
    // MARK: - Variables
    static let identifier = "CustomTableViewCell"
    
    let titleLabel: UILabel = UILabel()
    let actionButton: UIImageView = UIImageView()
    
    private let separatorLine: UIView = UIView()
    var buttonAction: (() -> Void)?
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func hideSeparator(_ hide: Bool) {
        separatorLine.isHidden = hide
    }
    
    // MARK: - Private funcs
    private func configureUI() {
        configureTitleLabel()
        configureActionButton()
        configureSeparatorLine()
    }
    
    private func configureTitleLabel() {
        titleLabel.font = FontManager.shared.font(for: .commonInformation)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
        titleLabel.pinCenterY(to: contentView)
    }
    
    private func configureActionButton() {
        actionButton.tintColor = .black
        actionButton.image = Constants.Images.multiply
        
        contentView.addSubview(actionButton)
//        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
//        actionButton.isEnabled = false
        actionButton.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
        actionButton.pinCenterY(to: contentView)
        actionButton.setHeight(Constants.Dimensions.buttonSize)
        actionButton.setWidth(Constants.Dimensions.buttonSize)
        
        titleLabel.pinRight(to: actionButton.leadingAnchor, Constants.Dimensions.titleRightMargin, .lsOE)
    }
    
    private func configureSeparatorLine() {
        separatorLine.backgroundColor = Common.Colors.separator
        
        contentView.addSubview(separatorLine)

        separatorLine.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
        separatorLine.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
        separatorLine.pinBottom(to: contentView.bottomAnchor)
        separatorLine.setHeight(Common.Dimensions.separatorHeight)
    }
    
    // MARK: - Objc funcs
    @objc
    private func buttonTapped() {
        buttonAction?()
    }
}
