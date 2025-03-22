//
//  UniversityTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 26.12.2024.
//

import UIKit

class UniversityTableViewCell: UITableViewCell {
    typealias Constants = AllConstants.UniversityTableViewCell.Dimensions
    typealias Common = AllConstants.Common
    
    var favoriteButtonTapped: ((_: UIButton, _: Bool) -> Void)?
    
    // MARK: - Variables
    static let identifier = "UniversityTableViewCell"
    
    let universityView: UIUniversityView = UIUniversityView()
    
    private let shimmerLayer: UIShimmerView = UIShimmerView()
    
    private let separatorLine: UIView = UIView()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private funcs
    private func configureUI() {
        backgroundColor = .white
        configureUniversityView()
        configureSeparatorLine()
        configureShimmerLayer()
    }
    
    private func configureUniversityView() {
        contentView.addSubview(universityView)
        universityView.favoriteButton.addTarget(
            self,
            action: #selector(favoriteButtonTapped(_:)),
            for: .touchUpInside
        )
        
        universityView.pinTop(to: contentView.topAnchor, Constants.universityTopMargin)
        universityView.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
        universityView.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
    }
    
    private func configureSeparatorLine() {
        contentView.addSubview(separatorLine)
        
        separatorLine.backgroundColor = Common.Colors.separator

        separatorLine.pinTop(to: universityView.bottomAnchor, Constants.separatorTopMargin)
        separatorLine.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
        separatorLine.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
        separatorLine.pinBottom(to: contentView.bottomAnchor)
        separatorLine.setHeight(Common.Dimensions.separatorHeight)
    }
    
    private func configureShimmerLayer() {
        contentView.addSubview(shimmerLayer)
        
        shimmerLayer.pinTop(to: contentView.topAnchor, Constants.shimmerVerticalMargin)
        shimmerLayer.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
        shimmerLayer.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
        shimmerLayer.pinBottom(to: contentView.bottomAnchor, Constants.shimmerVerticalMargin)
        shimmerLayer.setHeight(Constants.shimmerHeight)
        shimmerLayer.layer.cornerRadius = Constants.shimmerRadius
    }
    
    // MARK: - Methods
    func configure(with viewModel: UniversityViewModel) {
        universityView.configure(with: viewModel)
        shimmerLayer.isHidden = true
        shimmerLayer.stopAnimating()
        shimmerLayer.removeAllConstraints()
        isUserInteractionEnabled = true
        showAll()
    }
    
    func configureShimmer() {
        shimmerLayer.isHidden = false
        hideAll()
        shimmerLayer.startAnimating()
        isUserInteractionEnabled = false
    }
    
    private func hideAll() {
        separatorLine.isHidden = true
        universityView.isHidden = true
    }
    
    private func showAll() {
        separatorLine.isHidden = false
        universityView.isHidden = false
    }
    
    func hideSeparator(_ hide: Bool) {
        separatorLine.isHidden = hide
    }
    
    // MARK: - Objc funcs
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        let isFavorite = universityView.favoriteButton.image(for: .normal) == Common.Images.like
        let newImage = isFavorite ? Common.Images.unlike : Common.Images.like
        universityView.favoriteButton.setImage(newImage, for: .normal)
        favoriteButtonTapped?(sender, !isFavorite)
    }
}
