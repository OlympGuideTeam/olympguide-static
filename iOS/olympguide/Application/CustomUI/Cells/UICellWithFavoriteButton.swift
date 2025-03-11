//
//  UICellWithFavoriteButton.swift
//  olympguide
//
//  Created by Tom Tim on 11.03.2025.
//

import UIKit
import Combine

class UICellWithFavoriteButton: UITableViewCell {
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    private var cancellables = Set<AnyCancellable>()
    var isFavoriteButtonHidden: Bool = false
    var favoriteButtonTapped: ((_: UIButton, _: Bool) -> Void)?
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
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
        authManager.isAuthenticatedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuth in
                guard let self else { return }
                self.favoriteButton.isHidden = !isAuth || self.isFavoriteButtonHidden
            }.store(in: &cancellables)
    }
}

