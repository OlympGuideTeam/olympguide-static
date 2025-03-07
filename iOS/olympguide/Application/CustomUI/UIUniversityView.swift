//
//  UIUniversityView.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit
import Combine

final class UIUniversityView: UIView {
    private let logoImageView = UIImageViewWithShimmer(frame: .zero)
    private let nameLabel = UILabel()
    private let regionLabel = UILabel()
    private var authCancellable: AnyCancellable?
    
    var arrowIsHidden: Bool = true  {
        didSet {
            arrowImageView.isHidden = arrowIsHidden
            favoriteButton.isHidden = !arrowIsHidden
        }
    }
    
    var isExpanded: Bool = false {
        didSet {
            arrowImageView.image = isExpanded ?
                UIImage(systemName: "chevron.up") :
                UIImage(systemName: "chevron.down")
        }
    }
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
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
        regionLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.53)
                
        logoImageView.pinLeft(to: self.leadingAnchor)
        logoImageView.pinTop(to: self.topAnchor)
        logoImageView.setWidth(80)
        logoImageView.setHeight(80)
        
        regionLabel.pinTop(to: self.topAnchor)
        regionLabel.pinLeft(to: logoImageView.trailingAnchor, 15)
        regionLabel.pinRight(to: self.trailingAnchor)
        
        nameLabel.pinTop(to: regionLabel.bottomAnchor, 5)
        nameLabel.pinLeft(to: logoImageView.trailingAnchor, 15)
        nameLabel.pinRight(to: self.trailingAnchor, 37)
        
        favoriteButton.pinTop(to: regionLabel.bottomAnchor, 5)
        favoriteButton.pinRight(to: self.trailingAnchor)
        favoriteButton.setWidth(22)
        favoriteButton.setHeight(22)
        
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = .black
        arrowImageView.setWidth(17)
        arrowImageView.pinTop(to: regionLabel.bottomAnchor, 5)
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
        let newImageName = isFavorite ? "bookmark.fill" : "bookmark"
        favoriteButton.setImage(UIImage(systemName: newImageName), for: .normal)
        nameLabel.text = viewModel.name
        regionLabel.text = viewModel.region
        logoImageView.startShimmer()
        ImageLoader.shared.loadImage(from: viewModel.logoURL) { [weak self] image in
            guard let self = self, let image = image else { return }
            self.logoImageView.stopShimmer()
            self.logoImageView.image = image
        }
        nameLabel.calculateHeight(with: UIScreen.main.bounds.width - left - right - 80 - 37 - 15)
//        if !arrowIsHidden {
//            favoriteButton.isHidden = true
//        } else {
//            favoriteButton.isHidden = !AuthManager.shared.isAuthenticated
//        }
        favoriteButton.isHidden = true
        favoriteButton.tag = viewModel.universityID
    }
    
    func setupBindings() {
        authCancellable = AuthManager.shared.$isAuthenticated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuth in
                guard let self else { return }
                if !arrowIsHidden {
                    favoriteButton.isHidden = true
                } else {
                    favoriteButton.isHidden = !isAuth
                }
            }
    }
}
