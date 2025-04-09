//
//  GoogleSignInButtonTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 08.04.2025.
//

import UIKit

class GoogleSignInButtonTableViewCell: UITableViewCell {
    typealias Constants = AllConstants.ProfileButtonTableViewCell
    
    static let reuseIdentifier = "GoogleSignInButtonTableViewCell"
    
    let actionButton: UIButton = {
            var configuration = UIButton.Configuration.plain()
            configuration.title = "Войти через Google"
            configuration.baseBackgroundColor = .white
            configuration.baseForegroundColor = .black
            
            configuration.imagePadding = 8
            
            configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20)
            
            if let googleIcon = UIImage(named: "google_logo")?.withRenderingMode(.alwaysOriginal) {
                configuration.image = googleIcon
            }
            
            let button = UIButton(configuration: configuration, primaryAction: nil)
            
            button.layer.cornerRadius = 13
            button.layer.masksToBounds = true
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = Constants.Dimensions.buttonBorderWidth
            button.translatesAutoresizingMaskIntoConstraints = false
            
            return button
        }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        contentView.addSubview(actionButton)
        actionButton.pinTop(to: contentView.topAnchor, 8)
        actionButton.pinBottom(to: contentView.bottomAnchor, 8)
        actionButton.pinLeft(to: contentView.leadingAnchor, 20)
        actionButton.pinRight(to: contentView.trailingAnchor, 20)
        actionButton.setHeight(54)
        
        actionButton.addTarget(
            nil,
            action: #selector(buttonTouchDown(_:)),
            for: .touchDown
        )
        actionButton.addTarget(
            nil,
            action: #selector(buttonTouchUp(_:)),
            for: [.touchUpInside, .touchDragExit, .touchCancel]
        )
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(
            withDuration: Constants.Dimensions.animationDuration,
            delay: 0,
            options: [.curveEaseIn, .allowUserInteraction]
        ) {
            sender.transform = CGAffineTransform(
                scaleX: Constants.Dimensions.buttonScale,
                y: Constants.Dimensions.buttonScale
            )
        }
    }
    
    @objc
    private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(
            withDuration: Constants.Dimensions.animationDuration,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction]
        ) {
            sender.transform = .identity
        }
    }
}

