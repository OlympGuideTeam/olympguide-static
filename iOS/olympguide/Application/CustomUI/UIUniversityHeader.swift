//
//  UIUniversityHeader.swift
//  olympguide
//
//  Created by Tom Tim on 04.03.2025.
//

import UIKit

final class UIUniversityHeader: UITableViewHeaderFooterView {
    static let identifier = "UIUniversityHeader"
    private let universityView: UIUniversityView = UIUniversityView()
    private var isExpanded: Bool = false
    private let background = UIView()
    
    var toggleSection: ((_: Int) -> Void)?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureLayouts()
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(headerTapped)
        )
        contentView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBackgroundView() {

        contentView.addSubview(background)
        background.backgroundColor = .red
        background.pinTop(to: contentView.topAnchor, 5)
        background.pinBottom(to: contentView.bottomAnchor, 5)
        background.pinRight(to: contentView.trailingAnchor, 7)
        background.pinLeft(to: contentView.leadingAnchor, 7)
        background.layer.cornerRadius = 10
        background.backgroundColor = UIColor(hex: "#E0E8FE")
    }
    
    private func configureLayouts() {
        configureBackgroundView()
        configureUniversityView()
        
    }
    
    private func configureUniversityView() {
        contentView.addSubview(universityView)
        universityView.pinTop(to: contentView.topAnchor, 20)
        universityView.pinLeft(to: contentView.leadingAnchor, 20)
        universityView.pinRight(to: contentView.trailingAnchor, 20)
        universityView.pinBottom(to: contentView.bottomAnchor, 15)
    }
    
    func configure(
        with viewModel: UniversityViewModel,
        isExpanded: Bool
    ) {
        universityView.configure(with: viewModel, 20, 20)
        self.isExpanded = isExpanded
        background.backgroundColor = isExpanded ? UIColor(hex: "#E0E8FE") : .clear
    }
    
    @objc func headerTapped() {
        isExpanded.toggle()
        background.backgroundColor = isExpanded ? UIColor(hex: "#E0E8FE") : .clear
        toggleSection?(self.tag)
    }
}
