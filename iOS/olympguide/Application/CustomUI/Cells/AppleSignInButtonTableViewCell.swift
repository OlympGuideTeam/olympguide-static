//
//  AppleSignInButtonCell.swift
//  olympguide
//
//  Created by Tom Tim on 12.04.2025.
//

import AuthenticationServices
import UIKit

class AppleSignInButtonTableViewCell: UITableViewCell {
    typealias Constants = AllConstants.ProfileButtonTableViewCell
    
    static let reuseIdentifier = "AppleSignInButtonTableViewCell"
    
    let actionButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 19, bottom: 10, trailing: 19)
        
        // Настройка текста
        let attributedString = AttributedString(
            "Продолжить с Apple",
            attributes: AttributeContainer([
                .font: Constants.Font.button,
                .foregroundColor: UIColor.black
            ])
        )
        configuration.attributedTitle = attributedString
        
        // Настройка иконки Apple
        let appleLogo = UIImage(systemName: "apple.logo")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 19, weight: .semibold))
        configuration.image = appleLogo
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8
        
        // Создаем кнопку с конфигурацией
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.backgroundColor = .white
        button.layer.borderWidth = Constants.Dimensions.buttonBorderWidth
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = Constants.Dimensions.buttonRadius
        button.tintColor = .black
        
        // Поднимаем логотип на 3 пункта
        button.configuration?.imagePlacement = .leading
        button.configuration?.titleAlignment = .center
        button.transform = CGAffineTransform(translationX: 0, y: -3)
        
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
            self,
            action: #selector(buttonTouchDown(_:)),
            for: .touchDown
        )
        actionButton.addTarget(
            self,
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
            sender.transform = CGAffineTransform(translationX: 0, y: -3)
                .scaledBy(x: Constants.Dimensions.buttonScale, y: Constants.Dimensions.buttonScale)
        }
    }
    
    @objc
    private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(
            withDuration: Constants.Dimensions.animationDuration,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction]
        ) {
            sender.transform = CGAffineTransform(translationX: 0, y: -3)
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let convertedPoint = actionButton.convert(point, from: self)
        return actionButton.point(inside: convertedPoint, with: event)
    }
}
