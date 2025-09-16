//
//  ProfileButtonTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 10.01.2025.
//

import UIKit

class ProfileButtonTableViewCell: UITableViewCell {
    typealias Constants = AllConstants.ProfileButtonTableViewCell
    typealias Common = AllConstants.Common
    
    static let reuseIdentifier = "ProfileButtonTableViewCell"
    
    let actionButton: UIButton = UIButton(type: .system)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white
        
//        actionButton.titleLabel?.font = FontManager.shared.font(for: .commonInformation)
        actionButton.titleLabel?.font = Constants.Font.button
        actionButton.layer.cornerRadius = Constants.Dimensions.buttonRadius
        actionButton.layer.borderWidth = Constants.Dimensions.buttonBorderWidth
        actionButton.titleLabel?.tintColor = Common.Colors.text
        
        contentView.addSubview(actionButton)
        
        actionButton.pinTop(to: contentView.topAnchor, Constants.Dimensions.buttonVerticalMargin)
        actionButton.pinBottom(to: contentView.bottomAnchor, Constants.Dimensions.buttonVerticalMargin)
        actionButton.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
        actionButton.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
        actionButton.setHeight(Constants.Dimensions.buttonHeight)
    }
    
    func configure(title: String, borderColor: UIColor?, textColor: UIColor) {
        actionButton.setTitle(title, for: .normal)
        actionButton.layer.borderColor = borderColor?.cgColor
        actionButton.setTitleColor(textColor, for: .normal)
        
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
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let convertedPoint = actionButton.convert(point, from: self)
        return actionButton.point(inside: convertedPoint, with: event)
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
