//
//  FieldsTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 11.01.2025.
//

import UIKit

class FieldTableViewCell: UITableViewCell {
    typealias Constants = AllConstants.FieldTableViewCell
    typealias Common = AllConstants.Common
    
    // MARK: - Variables
    static let identifier = "FieldTableViewCell"
    
    private let information: UIStackView = UIStackView()
    
    var leftConstraint: CGFloat = Constants.Dimensions.leadingMargin {
        didSet {
            for constraint in contentView.constraints {
                if constraint.firstAttribute == .leading || constraint.firstAttribute == .left {
                    constraint.constant = leftConstraint
                }
            }
            contentView.layoutIfNeeded()
        }
    }
    
    // MARK: - Lifecycle
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private funcs
    private func setupUI() {
        contentView.addSubview(information)
        
        information.pinTop(to: contentView.topAnchor, Constants.Dimensions.topMargin)
        information.pinLeft(to: contentView.leadingAnchor, leftConstraint)
        information.pinBottom(to: contentView.bottomAnchor, Constants.Dimensions.bottomMargin)
        information.pinRight(to: contentView.trailingAnchor, Common.Dimensions.horizontalMargin)
    }
    
    // MARK: - Methods
    func configure(with viewModel: FieldViewModel) {
        information.configure(
            with: viewModel.code,
            and: viewModel.name,
            width: nil
        )
    }
}
