//
//  OlympiadTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 09.01.2025.
//

import UIKit
import Combine

// MARK: - Constants
fileprivate enum Constants {
    enum Identifier {
        static let cellIdentifier = "OlympiadTableViewCell"
    }
    
    enum Images {
        static let bookmark = "bookmark"
        static let bookmarkFill = "bookmark.fill"
        static let placeholder = "photo"
    }
    
    enum Colors {
        static let separatorColor = UIColor(hex: "#E7E7E7")
        static let levelAndProfileTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.53)
    }
    
    enum Fonts {
        static let nameLabelFont = FontManager.shared.font(for: .commonInformation)
        static let levelAndProfileLabelFont = FontManager.shared.font(for: .additionalInformation)
    }
    
    enum Dimensions {
        static let logoTopMargin: CGFloat = 30
        static let logoLeftMargin: CGFloat = 15
        static let logoSize: CGFloat = 80
        static let interItemSpacing: CGFloat = 20
        static let nameLabelBottomMargin: CGFloat = 20
        static let favoriteButtonSize: CGFloat = 22
        static let separatorHeight: CGFloat = 1
        static let separatorHorizontalInset: CGFloat = 20
    }
}

class OlympiadTableViewCell: UICellWithFavoriteButton {
    
    // MARK: - Variables
    static let identifier = Constants.Identifier.cellIdentifier
    
    private let nameLabel = UILabel()
    private let levelAndProfileLabel = UILabel()
    private let benefitLabel: UILabel = UILabel()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.separatorColor
        return view
    }()
    
    private let shimmerLayer: UIShimmerView = UIShimmerView()
    
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(levelAndProfileLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(separatorLine)
        contentView.addSubview(shimmerLayer)
        contentView.addSubview(benefitLabel)
        

        // Configure nameLabel
        nameLabel.font = Constants.Fonts.nameLabelFont
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        // Configure regionLabel
        levelAndProfileLabel.font = Constants.Fonts.levelAndProfileLabelFont
        levelAndProfileLabel.textColor = Constants.Colors.levelAndProfileTextColor
        
        benefitLabel.font = Constants.Fonts.levelAndProfileLabelFont
        benefitLabel.textColor = Constants.Colors.levelAndProfileTextColor
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        
        levelAndProfileLabel.pinTop(to: contentView.topAnchor, 20)
        levelAndProfileLabel.pinLeft(to: contentView.leadingAnchor, Constants.Dimensions.interItemSpacing)
        levelAndProfileLabel.pinRight(to: contentView.trailingAnchor, Constants.Dimensions.interItemSpacing)
        
        nameLabel.pinTop(to: levelAndProfileLabel.bottomAnchor, 5)
        nameLabel.pinLeft(to: contentView.leadingAnchor, Constants.Dimensions.interItemSpacing)
        nameLabel.pinRight(to: favoriteButton.leadingAnchor, Constants.Dimensions.interItemSpacing)
//        nameLabel.pinBottom(to: contentView.bottomAnchor, Constants.Dimensions.nameLabelBottomMargin)
        
        favoriteButton.pinTop(to: levelAndProfileLabel.bottomAnchor, 5)
        favoriteButton.pinRight(to: contentView.trailingAnchor, Constants.Dimensions.interItemSpacing)
        favoriteButton.setWidth(Constants.Dimensions.favoriteButtonSize)
        favoriteButton.setHeight(Constants.Dimensions.favoriteButtonSize)
        
        benefitLabel.pinTop(to: nameLabel.bottomAnchor, 5)
        benefitLabel.pinLeft(to: contentView.leadingAnchor, 20)
        benefitLabel.pinRight(to: contentView.trailingAnchor, 20)
        benefitLabel.pinBottom(to: contentView.bottomAnchor, 20)
        
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
    func configure(
        with viewModel: OlympiadViewModel,
        isFaforiteButtonVisible: Bool = true
    ) {
        nameLabel.text = viewModel.name
        levelAndProfileLabel.text = "\(viewModel.level) уровень | \(viewModel.profile)"
        benefitLabel.text = nil
        shimmerLayer.isHidden = true
        shimmerLayer.stopAnimating()
        shimmerLayer.removeAllConstraints()
        isUserInteractionEnabled = true
        let newImageName = viewModel.like ? Constants.Images.bookmarkFill : Constants.Images.bookmark
        favoriteButton.setImage(UIImage(systemName: newImageName), for: .normal)
        favoriteButton.isHidden = AuthManager.shared.isAuthenticated ? false : true
        favoriteButton.tag = viewModel.olympiadId
        
        if isFaforiteButtonVisible && AuthManager.shared.isAuthenticated {
            favoriteButton.isHidden = false
        }
    }
    
    func configure(
        with viewModel: OlympiadWithBenefitViewModel
    ) {
        nameLabel.text = viewModel.olympiadName
        let level = "\(String(repeating: "I", count: viewModel.olympiadLevel)) уровень"
        levelAndProfileLabel.text = "\(level) | \(viewModel.olympiadProfile)"
        let diploma = viewModel.minDiplomaLevel == 1 ? "Победитель" : "Призёр"
        let benefit = viewModel.isBVI ? "БВИ" : "100 баллов"
        benefitLabel.text = "\(viewModel.minClass) класс | \(diploma) | \(benefit)"
        shimmerLayer.isHidden = true
        shimmerLayer.stopAnimating()
        shimmerLayer.removeAllConstraints()

        isUserInteractionEnabled = true
        
        favoriteButton.isHidden = true
    }
    
    func configureShimmer() {
        shimmerLayer.isHidden = false
        shimmerLayer.startAnimating()
        isUserInteractionEnabled = false
    }
    
    func hideSeparator(_ hide: Bool) {
        separatorLine.isHidden = hide
    }
    
    // MARK: - Objc funcs
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        let isFavorite = favoriteButton.image(for: .normal) == UIImage(systemName: Constants.Images.bookmarkFill)
        let newImageName = isFavorite ? Constants.Images.bookmark : Constants.Images.bookmarkFill
        favoriteButton.setImage(UIImage(systemName: newImageName), for: .normal)
        favoriteButtonTapped?(sender, !isFavorite)
    }
}


class UICellWithFavoriteButton: UITableViewCell {
    private var authCancellable: AnyCancellable?
    var isFavoriteButtonHidden: Bool = false
    var favoriteButtonTapped: ((_: UIButton, _: Bool) -> Void)?
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: Constants.Images.bookmark), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBindings()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBindings() {
        authCancellable = AuthManager.shared.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuth in
                guard let self else { return }
                self.favoriteButton.isHidden = !isAuth || self.isFavoriteButtonHidden
            }
    }
}
