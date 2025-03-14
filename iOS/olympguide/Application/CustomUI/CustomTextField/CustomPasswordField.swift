//
//  CustomPasswordField.swift
//  olympguide
//
//  Created by Tom Tim on 30.01.2025.
//

import UIKit

class CustomPasswordField: CustomTextField, HighlightableField {
    typealias Constants = AllConstants.CustomPasswordField

    var isWrong: Bool = false
    
    var savedText: String? = nil
    
    override init(with title: String) {
        super.init(with: title)
        setSecureTextEntry(true)
        setActionButtonImage(Constants.Images.show)
        setActionButtonTarget(
            self,
            #selector(showPassword),
            for: .touchDown
        )
        addActionButtonTarget(
            self,
            #selector(hidePassword),
            for: [
                .touchUpInside,
                .touchUpOutside,
                .touchCancel
            ]
        )
        setTextFieldType(.default, .newPassword)
        configureVisiblePasswordField()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setSecureTextEntry(true)
        setActionButtonImage(Constants.Images.show)
        setActionButtonTarget(self, #selector(showPassword), for: .touchDown)
    }
    
    let visiblePassword = UILabel()
    
    func configureVisiblePasswordField() {
        self.addSubview(visiblePassword)
        visiblePassword.font =  FontManager.shared.font(for: .textField)
        visiblePassword.textColor = .black
        visiblePassword.pinTop(to: textField.topAnchor)
        visiblePassword.pinLeft(to: textField.leadingAnchor)
        visiblePassword.pinRight(to: textField.trailingAnchor)
        visiblePassword.pinBottom(to: textField.bottomAnchor)
        visiblePassword.alpha = 0
    }
    @objc private func hidePassword() {
        setActionButtonImage(Constants.Images.show)
        visiblePassword.alpha = 0
        textField.alpha = 1
    }
    
    @objc private func showPassword() {
        setActionButtonImage(Constants.Images.hide)
        visiblePassword.text = textField.text
        visiblePassword.alpha = 1
        textField.alpha = 0
    }
}
