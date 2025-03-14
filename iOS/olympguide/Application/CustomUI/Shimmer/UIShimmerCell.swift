//
//  UIShimmerCell.swift
//  olympguide
//
//  Created by Tom Tim on 14.03.2025.
//

import UIKit

final class ShimmerCell: UITableViewCell {
    static let identifier = "ShimmerCell"
    
    private let shimmerView = UIShimmerView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        shimmerView.translatesAutoresizingMaskIntoConstraints = false
        shimmerView.layer.cornerRadius = 8
        shimmerView.clipsToBounds = true
        contentView.addSubview(shimmerView)
        
        isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            shimmerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            shimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shimmerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            shimmerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            shimmerView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopShimmering()
    }
    
    func startShimmering() {
        shimmerView.startAnimating()
    }
    
    func stopShimmering() {
        shimmerView.stopAnimating()
    }
}
