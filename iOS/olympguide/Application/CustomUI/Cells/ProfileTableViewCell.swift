//
//  ProfileTableViewCell.swift
//  olympguide
//
//  Created by Tom Tim on 10.01.2025.
//

import UIKit 

class ProfileTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "ProfileTableViewCell"
    
    let label = UILabel()
    private let detailLabel = UILabel()
    private let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
    private let separatorLine = UIView()

    // MARK: - Инициализация
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label.font = FontManager.shared.font(for: .commonInformation)
        
        detailLabel.font = FontManager.shared.font(for: .additionalInformation)
        detailLabel.textColor = .gray
        
        chevronImageView.tintColor = .black
        
        separatorLine.backgroundColor = UIColor(hex: "#E7E7E7")
        
        // Добавляем сабвью один раз
        contentView.addSubview(label)
        contentView.addSubview(detailLabel)
        contentView.addSubview(chevronImageView)
        contentView.addSubview(separatorLine)
        
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Публичный метод для конфигурации
    func configure(title: String, detail: String? = nil) {
        label.text = title
        detailLabel.text = detail
    }
    
    // MARK: - Пример метода для установки констрейнов
    private func setupConstraints() {
        chevronImageView.pinCenterY(to: contentView.centerYAnchor)
        chevronImageView.pinRight(to: contentView.trailingAnchor, 20)
        chevronImageView.setWidth(13)
        chevronImageView.setHeight(22)
        
        label.pinTop(to: contentView.topAnchor, 21)
        label.pinLeft(to: contentView.leadingAnchor, 20)
        
        detailLabel.pinTop(to: label.bottomAnchor, 4)
        detailLabel.pinLeft(to: contentView.leadingAnchor, 20)
        detailLabel.pinBottom(to: contentView.bottomAnchor, 21)
        
        separatorLine.pinLeft(to: contentView.leadingAnchor, 20)
        separatorLine.pinRight(to: contentView.trailingAnchor, 20)
        separatorLine.pinBottom(to: contentView.bottomAnchor)
        separatorLine.setHeight(1)
    }
    
    func hideSeparator(_ hide: Bool) {
        separatorLine.isHidden = hide
    }
}
