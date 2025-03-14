//
//  OptionsContainerView.swift
//  olympguide
//
//  Created by Tom Tim on 13.03.2025.
//

import UIKit

final class OptionsContainerView: UIView {
    var cancleButtonWasTapped: (() -> Void)?
    var saveButtonWasTapped: (() -> Void)?
    
    var title: String?
    
    private let titleLabel: UILabel = UILabel()
    private let cancelButton: UIButton = UIButton()
    private let saveButton: UIButton = UIButton()
    
    func configure(
        count: Int,
        tableView: UITableView,
        searchBar: CustomTextField? = nil,
        selectedScrollContainer: UIView? = nil,
        selectedScrollView: UIView? = nil
    ) {
        configurePeak()
        configureTitleLabel()
        configureCancelButton()
        configureSaveButton()
        
        if count >= 6,
            let searchBar = searchBar,
           let selectedScrollContainer = selectedScrollContainer,
           let selectedScrollView = selectedScrollView
        {
            configureSearchBar(searchBar)
            configureSelectedScrollContainer(
                selectedScrollContainer,
                searchBar,
                selectedScrollView
            )
        }
        
        configureTableView(tableView, count: count, selectedScrollContainer)
    }
    
    private func configurePeak() {
        let peak: UIView = UIView()
        peak.backgroundColor = UIColor(hex: "#D9D9D9")
        peak.layer.cornerRadius = 1.0
        
        addSubview(peak)
        peak.frame = CGRect(
            x: (UIScreen.main.bounds.width - 45.0) / 2,
            y: 6.0,
            width: 45.0,
            height: 3.0
        )
    }
    
    private func configureTitleLabel() {
        titleLabel.text = title
        titleLabel.font = FontManager.shared.font(for: .optionsVCTitle)
        titleLabel.textColor = .black
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.numberOfLines = 1
        
        addSubview(titleLabel)
        titleLabel.pinTop(to: topAnchor, 21.0)
        titleLabel.pinLeft(to: leadingAnchor, 20.0)
        titleLabel.pinRight(to: trailingAnchor, 20.0)
    }
    
    private func configureCancelButton() {
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.backgroundColor = UIColor(hex: "#E7E7E7")
        cancelButton.titleLabel?.font = FontManager.shared.font(for: .bigButton)
        cancelButton.layer.cornerRadius = 14.0
        
        cancelButton.addTarget(nil, action: #selector(buttonTouchDown), for: .touchDown)
        cancelButton.addTarget(nil, action: #selector(cancelButtonTouchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        addSubview(cancelButton)
        cancelButton.pinBottom(to: bottomAnchor, 37.0)
        cancelButton.setHeight(48.0)
        cancelButton.pinLeft(to: leadingAnchor, 20.0)
        cancelButton.pinRight(to: centerXAnchor, 2.5)
    }
    
    private func configureSaveButton() {
        saveButton.setTitle("Применить", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.backgroundColor = UIColor(hex: "#E0E8FE")
        saveButton.titleLabel?.font = FontManager.shared.font(for: .bigButton)
        saveButton.layer.cornerRadius = 14.0
        
        saveButton.addTarget(nil, action: #selector(buttonTouchDown), for: .touchDown)
        saveButton.addTarget(nil, action: #selector(saveButtonTouchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        addSubview(saveButton)
        pinBottom(to: bottomAnchor, 37.0)
        saveButton.setHeight(48.0)
        saveButton.pinRight(to: trailingAnchor, 20.0)
        saveButton.pinLeft(to: centerXAnchor, 2.5)
    }
    
    private func configureSearchBar(_ searchBar: CustomTextField) {
        addSubview(searchBar)
        searchBar.pinTop(to: titleLabel.bottomAnchor, 5)
        searchBar.pinLeft(to: leadingAnchor, 20)
    }
    
    private func configureSelectedScrollContainer(
        _ selectedScrollContainer: UIView,
        _ searchBar: CustomTextField,
        _ selectedScrollView: UIView
    ) {
        addSubview(selectedScrollContainer)
        
        selectedScrollContainer.pinTop(to: searchBar.bottomAnchor)
        selectedScrollContainer.pinLeft(to: leadingAnchor)
        selectedScrollContainer.pinRight(to: trailingAnchor)
        
        selectedScrollContainer.addSubview(selectedScrollView)
        selectedScrollView.pinLeft(to: leadingAnchor)
        selectedScrollView.pinRight(to: trailingAnchor)
        selectedScrollView.pinTop(to: selectedScrollContainer, 9)
        
        selectedScrollView.alpha = 0
//        selectedScrollView.delegate = self
    }
    
    private func configureTableView(
        _ tableView: UITableView,
        count: Int,
        _ selectedScrollContainer: UIView? = nil
    ) {
        tableView.register(OptionsTableViewCell.self, forCellReuseIdentifier: OptionsTableViewCell.identifier)
        tableView.separatorStyle = .none
        
        addSubview(tableView)
        if count >= 6, let selectedScrollContainer = selectedScrollContainer {
            tableView.pinTop(to: selectedScrollContainer.bottomAnchor, 5)
        } else {
            tableView.pinTop(to: titleLabel.bottomAnchor, 5)
        }
        
        tableView.pinLeft(to: leadingAnchor)
        tableView.pinRight(to: trailingAnchor)
        tableView.pinBottom(to: saveButton.topAnchor)
        
        tableView.isScrollEnabled = count >= 6
        
        backgroundColor = .white
    }
    
    
    @objc
    private func buttonTouchDown(_ sender: UIButton) {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseIn, .allowUserInteraction]
        ) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func buttonTouchUp(_ sender: UIButton) {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: [.curveEaseOut, .allowUserInteraction]
        ) {
            sender.transform = .identity
        }
    }
    
    @objc
    func cancelButtonTouchUp(_ sender: UIButton) {
        buttonTouchUp(sender)
        cancleButtonWasTapped?()
    }
    
    @objc
    func saveButtonTouchUp(_ sender: UIButton) {
        buttonTouchUp(sender)
        saveButtonWasTapped?()
    }
}
