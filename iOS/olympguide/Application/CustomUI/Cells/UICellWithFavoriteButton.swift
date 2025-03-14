//
//  UICellWithFavoriteButton.swift
//  olympguide
//
//  Created by Tom Tim on 11.03.2025.
//

import UIKit
import Combine

class UICellWithFavoriteButton: UITableViewCell {
    typealias Common = AllConstants.Common

    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    private var cancellables = Set<AnyCancellable>()
    var isFavoriteButtonHidden: Bool = false
    var favoriteButtonTapped: ((_: UIButton, _: Bool) -> Void)?
    let favoriteButton: UIButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureFavoriteButton()
        setupBindings()
    }
    
    private func configureFavoriteButton() {
        favoriteButton.tintColor = .black
        favoriteButton.contentHorizontalAlignment = .fill
        favoriteButton.contentVerticalAlignment = .fill
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        favoriteButton.setImage(Common.Images.unlike, for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBindings() {
        authManager.isAuthenticatedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuth in
                guard let self else { return }
                self.favoriteButton.isHidden = !isAuth || self.isFavoriteButtonHidden
            }.store(in: &cancellables)
    }
}

