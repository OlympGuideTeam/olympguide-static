//
//  UniversityTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 26.12.2024.
//

import UIKit

// MARK: - Constants
fileprivate enum Constants {
    enum Identifier {
        static let cellIdentifier = "UniversityTableViewCell"
    }
    
    enum Images {
        static let bookmark = "bookmark"
        static let bookmarkFill = "bookmark.fill"
        static let placeholder = "photo"
    }
    
    enum Colors {
        static let separatorColor = UIColor(hex: "#E7E7E7")
        static let regionTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.53)
    }
    
    enum Fonts {
        static let nameLabelFont = FontManager.shared.font(for: .commonInformation)
        static let regionLabelFont = FontManager.shared.font(for: .region)
    }
    
    enum Dimensions {
        static let logoTopMargin: CGFloat = 30
        static let logoLeftMargin: CGFloat = 15
        static let logoSize: CGFloat = 80
        static let interItemSpacing: CGFloat = 15
        static let nameLabelBottomMargin: CGFloat = 20
        static let favoriteButtonSize: CGFloat = 22
        static let separatorHeight: CGFloat = 1
        static let separatorHorizontalInset: CGFloat = 20
    }
}

class UniversityTableViewCell: UITableViewCell {
    var favoriteButtonTapped: ((_: UIButton, _: Bool) -> Void)?
    
    // MARK: - Variables
    static let identifier = Constants.Identifier.cellIdentifier
    
    private let universityView: UIUniversityView = UIUniversityView()
    
    private let shimmerLayer: UIShimmerView = UIShimmerView()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.separatorColor
        return view
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private funcs
    private func setupUI() {
        contentView.addSubview(universityView)
        contentView.addSubview(separatorLine)
        contentView.addSubview(shimmerLayer)
        
        
        universityView.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        
        universityView.pinTop(to: contentView.topAnchor, 30)
        universityView.pinLeft(to: contentView.leadingAnchor, 15)
        universityView.pinRight(to: contentView.trailingAnchor, 15)
        
        separatorLine.pinTop(to: universityView.bottomAnchor, 20)
        separatorLine.pinLeft(to: contentView.leadingAnchor, Constants.Dimensions.separatorHorizontalInset)
        separatorLine.pinRight(to: contentView.trailingAnchor, Constants.Dimensions.separatorHorizontalInset)
        separatorLine.pinBottom(to: contentView.bottomAnchor)
        separatorLine.setHeight(Constants.Dimensions.separatorHeight)
        
        shimmerLayer.pinTop(to: contentView.topAnchor, 10)
        shimmerLayer.pinLeft(to: contentView.leadingAnchor, 20)
        shimmerLayer.pinRight(to: contentView.trailingAnchor, 20)
        shimmerLayer.pinBottom(to: contentView.bottomAnchor, 10)
        shimmerLayer.setHeight(75)
        shimmerLayer.layer.cornerRadius = 13
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
        let isFavorite = universityView.favoriteButton.image(for: .normal) == UIImage(systemName: Constants.Images.bookmarkFill)
        let newImageName = isFavorite ? Constants.Images.bookmark : Constants.Images.bookmarkFill
        universityView.favoriteButton.setImage(UIImage(systemName: newImageName), for: .normal)
        favoriteButtonTapped?(sender, !isFavorite)
    }
}
