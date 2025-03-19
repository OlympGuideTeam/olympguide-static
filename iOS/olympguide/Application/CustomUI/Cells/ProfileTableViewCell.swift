//
//  ProfileTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 10.01.2025.
//

import UIKit 

class ProfileTableViewCell: UITableViewCell {
    typealias Constants = AllConstants.ProfileTableViewCell
    typealias Common = AllConstants.Common
    
    static let reuseIdentifier = "ProfileTableViewCell"
    
    let label = UILabel()
    private let detailLabel = UILabel()
    private let chevronImageView = UIImageView(image: Constants.Images.chevronImage)
    private let separatorLine = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        label.font = FontManager.shared.font(for: .commonInformation)
        label.textColor = .black
        
        detailLabel.font = FontManager.shared.font(for: .additionalInformation)
        detailLabel.textColor = Common.Colors.additionalText
        
        chevronImageView.tintColor = Constants.Colors.chevronColor
        
        separatorLine.backgroundColor = Common.Colors.separator
        configureConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureConstraints() {
        contentView.addSubview(label)
        contentView.addSubview(detailLabel)
        contentView.addSubview(chevronImageView)
        contentView.addSubview(separatorLine)
        
        chevronImageView.pinCenterY(to: contentView.centerYAnchor)
        chevronImageView.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
        chevronImageView.setWidth(Constants.Dimensions.chevronWidth)
        chevronImageView.setHeight(Constants.Dimensions.chevronHeight)
        
        label.pinTop(to: contentView.topAnchor, Constants.Dimensions.verticalMargin)
        label.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
        
        detailLabel.pinTop(to: label.bottomAnchor, Constants.Dimensions.itemSpacing)
        detailLabel.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
        detailLabel.pinBottom(to: contentView.bottomAnchor, Constants.Dimensions.verticalMargin)
        
        separatorLine.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
        separatorLine.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
        separatorLine.pinBottom(to: contentView.bottomAnchor)
        separatorLine.setHeight(1)
    }
    
    func configure(title: String, detail: String? = nil) {
        label.text = title
        detailLabel.text = detail
    }
    
    func hideSeparator(_ hide: Bool) {
        separatorLine.isHidden = hide
    }
}
