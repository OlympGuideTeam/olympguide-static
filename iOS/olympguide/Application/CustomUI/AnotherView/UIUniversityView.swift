//
//  UIUniversityView.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit
import Combine

final class UIUniversityView: UIView {
    typealias Constants = AllConstants.UIUniversityView.Dimensions
    typealias Common = AllConstants.Common
    
    private let logoImageView = UIImageViewWithShimmer(frame: .zero)
    private let nameLabel = UILabel()
    private let regionLabel = UILabel()
    private var authCancellable: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    var arrowIsHidden: Bool = true  {
        didSet {
            arrowImageView.isHidden = arrowIsHidden
            favoriteButtonIsHidden = true
        }
    }
    
    var favoriteButtonIsHidden: Bool = false {
        didSet {
            favoriteButton.isHidden = favoriteButtonIsHidden
        }
    }
    
    var isExpanded: Bool = false {
        didSet {
            arrowImageView.image = isExpanded ?
                Common.Images.openedSection :
                Common.Images.closedSection
        }
    }
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(Common.Images.unlike, for: .normal)
        return button
    }()
    
    let arrowImageView: UIImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        configureLayout()
        setupBindings()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(logoImageView)
        addSubview(nameLabel)
        addSubview(regionLabel)
        addSubview(favoriteButton)
        addSubview(arrowImageView)

        logoImageView.contentMode = .scaleAspectFit
        
        nameLabel.font =  FontManager.shared.font(for: .commonInformation)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        regionLabel.font = FontManager.shared.font(for: .region)
        regionLabel.textColor = Common.Colors.additionalText
                
        logoImageView.pinLeft(to: self.leadingAnchor)
        logoImageView.pinTop(to: self.topAnchor)
        logoImageView.setWidth(Constants.imageSize)
        logoImageView.setHeight(Constants.imageSize)
        
        regionLabel.pinTop(to: self.topAnchor)
        regionLabel.pinLeft(to: logoImageView.trailingAnchor, Constants.itemsSpacing)
        regionLabel.pinRight(to: self.trailingAnchor)
        
        nameLabel.pinTop(to: regionLabel.bottomAnchor, Constants.nameLabelTopMargin)
        nameLabel.pinLeft(to: logoImageView.trailingAnchor, Constants.itemsSpacing)
        nameLabel.pinRight(
            to: self.trailingAnchor,
            Constants.itemsSpacing + Common.Dimensions.favoriteButtonSize
        )
        
        favoriteButton.pinTop(to: regionLabel.bottomAnchor, Constants.buttonTopMargin)
        favoriteButton.pinRight(to: self.trailingAnchor)
        favoriteButton.setWidth(Common.Dimensions.favoriteButtonSize)
        favoriteButton.setHeight(Common.Dimensions.favoriteButtonSize)
        
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = .black
        arrowImageView.setWidth(Constants.arrowImageSize)
        arrowImageView.pinTop(to: regionLabel.bottomAnchor, Constants.buttonTopMargin)
        arrowImageView.pinRight(to: self.trailingAnchor)
        arrowImageView.isHidden = true
        
        self.pinBottom(to: nameLabel.bottomAnchor, 0, .grOE)
        self.pinBottom(to: logoImageView.bottomAnchor, 0, .grOE)
    }
    
    func configure(
        with viewModel: UniversityViewModel,
        _ left: CGFloat = 15.0,
        _ right: CGFloat = 15.0
    ) {
        let isFavorite = viewModel.like
        let newImage = isFavorite ? Common.Images.like : Common.Images.unlike
        favoriteButton.setImage(newImage, for: .normal)
        nameLabel.text = viewModel.name
        regionLabel.text = viewModel.region
        logoImageView.startShimmer()
        ImageLoader.shared.loadImage(from: viewModel.logoURL) { [weak self] image in
            guard let self = self, let image = image else { return }
            self.logoImageView.stopShimmer()
            self.logoImageView.image = image
        }
        nameLabel.calculateHeight(
            with: UIScreen.main.bounds.width - left - right
            - Constants.imageSize - Common.Dimensions.favoriteButtonSize - 2 * Constants.itemsSpacing
        )
        if !arrowIsHidden {
            favoriteButton.isHidden = true
        } else {
            favoriteButton.isHidden = !authManager.isAuthenticated || favoriteButtonIsHidden
        }
        favoriteButton.tag = viewModel.universityID
    }
    
    func setupBindings() {
        authManager.isAuthenticatedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuth in
                guard let self else { return }
                if !arrowIsHidden {
                    favoriteButton.isHidden = true
                } else {
                    favoriteButton.isHidden = favoriteButtonIsHidden || !isAuth
                }
            }
            .store(in: &cancellables)
    }
}
