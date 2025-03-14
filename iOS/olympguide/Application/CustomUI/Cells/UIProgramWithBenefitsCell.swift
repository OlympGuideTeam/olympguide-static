//
//  UIProgramWithBenefitsCell.swift
//  olympguide
//
//  Created by Tom Tim on 05.03.2025.
//

import UIKit

final class UIProgramWithBenefitsCell : UITableViewCell {
    typealias Constants = AllConstants.UIProgramWithBenefitsCell.Dimensions
    typealias Common = AllConstants.Common
    
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
        configureNameStack()
        configureBenefitsStack()
        configureSeparatorView()
    }
    
    private func configureNameStack() {
        contentView.addSubview(nameStack)
        nameStack.pinTop(to: contentView.topAnchor, Constants.nameStackTopMargin)
        nameStack.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
        nameStack.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
    }
    
    private func configureBenefitsStack() {
        contentView.addSubview(benefitsStack)
        benefitsStack.pinTop(to: nameStack.bottomAnchor, Constants.benefitStackTopMargin)
        benefitsStack.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
        benefitsStack.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
        benefitsStack.pinBottom(to: contentView.bottomAnchor, Constants.benefitStackBottompMargin)
        benefitsStack.distribution = .fillEqually
        benefitsStack.axis = .vertical
        benefitsStack.spacing = Constants.benefitStackBottompSpacing
    }
    
    private func configureSeparatorView() {
        contentView.addSubview(separatorView)
        separatorView.pinLeft(to: contentView.leadingAnchor, Common.Dimensions.horizontalMargin)
        separatorView.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
        separatorView.pinBottom(to: contentView.bottomAnchor)
        separatorView.setHeight(Common.Dimensions.separatorHeight)
        separatorView.backgroundColor = Common.Colors.separator
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
