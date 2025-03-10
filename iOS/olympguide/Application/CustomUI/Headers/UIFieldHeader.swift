//
//  UIFieldHeader.swift
//  olympguide
//
//  Created by Tom Tim on 11.03.2025.
//

import UIKit

final class UIFieldHeader : UITableViewHeaderFooterView {
    static let identifier = "UIFieldHeader"
    
    var toggleSection: ((_: Int) -> Void)?
    
    private let fieldStackView: UIStackView = UIStackView()
    private let background: UIView = UIView()
    private let arrowImageView: UIImageView = UIImageView()
    
    private var isExpanded: Bool = false
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureLayouts()
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(headerTapped)
        )
        contentView.addGestureRecognizer(tapGesture)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayouts() {
        tintColor = .white
        configureBackgroundView()
        configureFieldStackView()
        configureArrowImageView()
    }
    
    private func configureBackgroundView() {
        contentView.addSubview(background)
        
        background.isUserInteractionEnabled = false
        
        background.backgroundColor = .white
        background.layer.cornerRadius = 13
        background.pinTop(to: contentView.topAnchor)
        background.pinBottom(to: contentView.bottomAnchor)
        background.pinLeft(to: contentView.leadingAnchor, 15)
        background.pinRight(to: contentView.trailingAnchor, 15)
        background.backgroundColor = UIColor(hex: "#E0E8FE")
    }
    
    private func configureFieldStackView() {
        contentView.addSubview(fieldStackView)
        fieldStackView.pinTop(to: contentView.topAnchor, 5)
        fieldStackView.pinLeft(to: contentView.leadingAnchor, 40)
        fieldStackView.pinBottom(to: contentView.bottomAnchor, 5)
        fieldStackView.pinRight(to: contentView.trailingAnchor, 20)
    }
    
    private func configureArrowImageView() {
        contentView.addSubview(arrowImageView)
        
        arrowImageView.isUserInteractionEnabled = false
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = .black
        arrowImageView.setWidth(17)
        
        arrowImageView.pinTop(to: contentView.topAnchor, 3)
        arrowImageView.pinLeft(to: contentView.leadingAnchor, 20)
    }
    
    private func updateApperance() {
        arrowImageView.image = isExpanded
        ? UIImage(systemName: "chevron.up")
        : UIImage(systemName: "chevron.down")
        
        background.backgroundColor = isExpanded
        ? UIColor(hex: "#E0E8FE")
        : .clear
    }
    
    func configure(
        name: String,
        code: String,
        isExpanded: Bool = false
    ) {
        self.isExpanded = isExpanded
        let capitalizeName = capitalizeFirstLetter(name)
        fieldStackView.configure(with: code, and: capitalizeName)
        updateApperance()
    }
    
    private func capitalizeFirstLetter(_ input: String) -> String {
        guard let firstChar = input.first else { return "" }
        return firstChar.uppercased() + input.dropFirst().lowercased()
    }
    
    @objc func headerTapped() {
        isExpanded.toggle()
        
        updateApperance()
        
        toggleSection?(self.tag)
    }
}
