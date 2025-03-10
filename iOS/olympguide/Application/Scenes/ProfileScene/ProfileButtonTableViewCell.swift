//
//  ProfileButtonTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 10.01.2025.
//

import UIKit

class ProfileButtonTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ProfileButtonTableViewCell"
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = FontManager.shared.font(for: .commonInformation)
        button.layer.cornerRadius = 13
        button.layer.borderWidth = 2
        button.titleLabel?.tintColor = .black
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(actionButton)
        
        actionButton.pinTop(to: contentView.topAnchor, 8)
        actionButton.pinBottom(to: contentView.bottomAnchor, 8)
        actionButton.pinLeft(to: contentView.leadingAnchor, 16)
        actionButton.pinRight(to: contentView.trailingAnchor, 16)
        actionButton.setHeight(54)
    }
    
    func configure(title: String, borderColor: UIColor?, textColor: UIColor) {
        actionButton.setTitle(title, for: .normal)
        actionButton.layer.borderColor = borderColor?.cgColor
        actionButton.setTitleColor(textColor, for: .normal)
        
        actionButton.addTarget(nil, action: #selector(buttonTouchDown(_:)), for: .touchDown)
        actionButton.addTarget(nil, action: #selector(buttonTouchUp(_:)), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let convertedPoint = actionButton.convert(point, from: self)
        return actionButton.point(inside: convertedPoint, with: event)
    }
    
    @objc
    private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction]) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc
    private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.curveEaseOut, .allowUserInteraction]) {
            sender.transform = .identity
        }
    }
}
