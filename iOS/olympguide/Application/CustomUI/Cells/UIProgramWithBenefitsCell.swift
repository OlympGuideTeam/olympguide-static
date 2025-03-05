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
        separatorView.backgroundColor = .systemGray5
    }
    
    func configure(with viewModel: BenefitsByPrograms.Load.ViewModel.BenefitViewModel) {
        nameStack.configure(with: viewModel.program.field, and: viewModel.program.programName)
        benefitsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for benefit in viewModel.benefitInformation {
            let bs = BenefitStackView()
            bs.benefitInfo = BenefitInfo(title: "ek", description: "frfr")
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(benefitTapped)
            )
            bs.addGestureRecognizer(tapGesture)
            bs.configure(with: benefit)
            
            benefitsStack.addArrangedSubview(bs)
        }
    }
    
    @objc func benefitTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? BenefitStackView else { return }
        view.openPage()
    }
}
