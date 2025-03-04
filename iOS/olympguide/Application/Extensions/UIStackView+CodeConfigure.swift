//
//  UIStackView+CodeConfigure.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit

extension UIStackView {
    func configure(with code: String, and name: String, weight: CGFloat = UIScreen.main.bounds.width - 129) {
        self.axis = .horizontal
        self.alignment = .top
        self.spacing = 0
        
        self.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for char in code {
            let label = UILabel()
            label.text = String(char)
            label.font = FontManager.shared.font(for: .commonInformation)
            label.textColor = .black
            label.textAlignment = .center
            if char == "." {
                label.setWidth(3)
            } else {
                label.setWidth(11)
            }
            self.addArrangedSubview(label)
        }
        
        let spaceLabel1 = UILabel()
        spaceLabel1.setWidth(4)
        let spaceLabel2 = UILabel()
        spaceLabel2.setWidth(2)
        self.addArrangedSubview(spaceLabel1)
        let dashLabel = UILabel()
        dashLabel.text = "-"
        dashLabel.font = FontManager.shared.font(for: .commonInformation)
        dashLabel.textColor = .black
        dashLabel.textAlignment = .center
        dashLabel.setWidth(11)
        self.addArrangedSubview(dashLabel)
        self.addArrangedSubview(spaceLabel2)
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = FontManager.shared.font(for: .commonInformation)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        nameLabel.lineBreakMode = .byWordWrapping
        self.addArrangedSubview(nameLabel)
        nameLabel.calculateHeight(with: weight)
    }
}
