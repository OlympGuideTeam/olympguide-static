//
//  UIUniversityHeader.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit

final class UIUniversityHeader : UITableViewHeaderFooterView {
    typealias Constants = AllConstants.UIFieldHeaderCell
    typealias Dimensions = AllConstants.UIFieldHeaderCell.Dimensions
    typealias Common = AllConstants.Common
    
    static let identifier = "UIUniversityHeader"
    let universityView: UIUniversityView = UIUniversityView()
    private var isExpanded: Bool = false
    private let background = UIView()
    
    var favoriteButtonTapped: ((_: UIButton, _: Bool) -> Void)?
    var toggleSection: ((_: Int) -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureLayouts()
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(headerTapped)
        )
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBackgroundView() {
        contentView.addSubview(background)
        background.backgroundColor = .red
        background.pinTop(to: contentView.topAnchor, 5)
        background.pinBottom(to: contentView.bottomAnchor, 5)
        background.pinRight(to: contentView.trailingAnchor, 7)
        background.pinLeft(to: contentView.leadingAnchor, 7)
        background.layer.cornerRadius = 10
        background.backgroundColor = UIColor(hex: "#E0E8FE")
    }
    
    private func configureLayouts() {
        tintColor = .white
        configureBackgroundView()
        configureUniversityView()
    }
    
    private func configureUniversityView() {
        contentView.addSubview(universityView)
        universityView.pinTop(to: contentView.topAnchor, 20)
        universityView.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
        universityView.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
        universityView.pinBottom(to: contentView.bottomAnchor, 15)
        
        universityView.favoriteButton.addTarget(
            self,
            action: #selector(favoriteButtonTapped(_:)),
            for: .touchUpInside
        )
    }
    
    func configure(
        with viewModel: UniversityViewModel,
        isExpanded: Bool
    ) {
        universityView.configure(
            with: viewModel,
            Common.Dimensions.horizontalMargin,
            Common.Dimensions.horizontalMargin
        )
        universityView.isExpanded = isExpanded
        universityView.arrowIsHidden = false
        self.isExpanded = isExpanded
        background.backgroundColor = isExpanded ? Common.Colors.accient : .clear
    }
    
    @objc func headerTapped() {
        isExpanded.toggle()
        universityView.isExpanded.toggle()
        background.backgroundColor = isExpanded ? Common.Colors.accient : .clear
        toggleSection?(self.tag)
    }
    
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        let isFavorite = universityView.favoriteButton.image(for: .normal) == Common.Images.like
        let newImage = isFavorite ? Common.Images.unlike : Common.Images.like
        universityView.favoriteButton.setImage(newImage, for: .normal)
        favoriteButtonTapped?(sender, !isFavorite)
    }
}

final class UIUniversityHeaderCell : UITableViewCell {
    typealias Constants = AllConstants.UIUniversityHeaderCell
    typealias Dimensions = Constants.Dimensions
    typealias Common = AllConstants.Common
    
    static let identifier = "UIUniversityHeaderCell"
    let universityView: UIUniversityView = UIUniversityView()
    private var isExpanded: Bool = false
    private let background = UIView()
    
    var favoriteButtonTapped: ((_: UIButton, _: Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayouts()
        selectionStyle = .none
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBackgroundView() {
        contentView.addSubview(background)
        background.backgroundColor = .red
        background.pinTop(to: contentView.topAnchor, Dimensions.backgroundVerticalMargin)
        background.pinBottom(to: contentView.bottomAnchor, Dimensions.backgroundVerticalMargin)
        background.pinRight(to: contentView.trailingAnchor, Dimensions.backgroundHorizontalMargin)
        background.pinLeft(to: contentView.leadingAnchor, Dimensions.backgroundHorizontalMargin)
        background.layer.cornerRadius = Dimensions.backgroundRadius
        background.backgroundColor = Common.Colors.accient
    }
    
    private func configureLayouts() {
        tintColor = .white
        configureBackgroundView()
        configureUniversityView()
    }
    
    private func configureUniversityView() {
        contentView.addSubview(universityView)
        universityView.pinTop(to: contentView.topAnchor, Dimensions.universityTopMargin)
        universityView.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
        universityView.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
        universityView.pinBottom(to: contentView.bottomAnchor, Dimensions.universityBottomMargin)
        
        universityView.favoriteButton.addTarget(
            self,
            action: #selector(favoriteButtonTapped(_:)),
            for: .touchUpInside
        )
    }
    
    func configure(
        with viewModel: UniversityViewModel,
        isExpanded: Bool
    ) {
        universityView.configure(
            with: viewModel,
            Common.Dimensions.horizontalMargin,
            Common.Dimensions.horizontalMargin
        )
        universityView.isExpanded = isExpanded
        universityView.arrowIsHidden = false
        self.isExpanded = isExpanded
        background.backgroundColor = isExpanded ? Common.Colors.accient : .clear
    }
    
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        let isFavorite = universityView.favoriteButton.image(for: .normal) == Common.Images.like
        let newImage = isFavorite ? Common.Images.unlike : Common.Images.like
        universityView.favoriteButton.setImage(newImage, for: .normal)
        favoriteButtonTapped?(sender, !isFavorite)
    }
}

