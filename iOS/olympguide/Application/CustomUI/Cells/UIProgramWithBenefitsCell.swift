//
//  UIProgramWithBenefitsCell.swift
//  olympguide
//
//  Created by Tom Tim on 05.03.2025.
//

import UIKit

final class UIProgramWithBenefitsCell : UITableViewCell {
    static let identifier = "UIProgramWithBenefitsCell"
    let benefitsStack: UIStackView = UIStackView()
    let nameStack: UIStackView = UIStackView()
    let separatorView: UIView = UIView()
    var benefitIsTapped: ((_: IndexPath) -> Void)?
    var shouldIgnoreHighlight = false
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayouts()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if shouldIgnoreHighlight {
            super.setHighlighted(false, animated: animated)
        } else {
            super.setHighlighted(highlighted, animated: animated)
        }
    }
    
    private func configureLayouts() {
        contentView.addSubview(nameStack)
        nameStack.pinTop(to: contentView.topAnchor, 10)
        nameStack.pinLeft(to: contentView.leadingAnchor, 20)
        nameStack.pinRight(to: contentView.trailingAnchor, 20)
        
        contentView.addSubview(benefitsStack)
        benefitsStack.pinTop(to: nameStack.bottomAnchor, 5)
        benefitsStack.pinLeft(to: contentView.leadingAnchor, 20)
        benefitsStack.pinRight(to: contentView.trailingAnchor, 20)
        benefitsStack.pinBottom(to: contentView.bottomAnchor, 10)
        benefitsStack.distribution = .fillEqually
        benefitsStack.axis = .vertical
        benefitsStack.spacing = 10
        
        contentView.addSubview(separatorView)
        separatorView.pinLeft(to: contentView.leadingAnchor, 20)
        separatorView.pinRight(to: contentView.trailingAnchor, 20)
        separatorView.pinBottom(to: contentView.bottomAnchor)
        separatorView.setHeight(1)
        separatorView.backgroundColor = UIColor(hex: "#D9D9D9")
    }
    
    func configure(with viewModel: ProgramWithBenefitsViewModel, indexPath: IndexPath) {
        nameStack.configure(with: viewModel.program.field, and: viewModel.program.programName)
        benefitsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, benefit) in viewModel.benefitInformation.enumerated() {
            let bs = BenefitStackView()
            bs.configure(with: benefit)
            bs.parentCell = self
            bs.tag = index
            bs.indexPath = indexPath
            benefitsStack.addArrangedSubview(bs)
        }
    }
    
    func hideSeparator(_ isHidden: Bool) {
        separatorView.isHidden = isHidden
    }
}
