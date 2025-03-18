//
//  CustomTextField.swift
//  olympguide
//
//  Created by Tom Tim on 30.01.2025.
//

import UIKit

// MARK: - Protocol
protocol CustomTextFieldDelegate: AnyObject {
    func action(_ searchBar: CustomTextField, textDidChange text: String)
}

// MARK: - CustomTextField
class CustomTextField: UIView {
    typealias Constants = AllConstants.CustomTextField
    typealias Common = AllConstants.Common
    
    // MARK: - Properties
    weak var delegate: (any CustomTextFieldDelegate)?
    
    private let titleLabel = UILabel()
    /*private*/ let textField = UITextField()
    private let actionButton = UIButton()
    var isActive = false
    
    // MARK: - Initializers
    init(with title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        setupView()
        configureTitleLabel()
        configureTextField()
        configureDeleteButton()
        addCloseButtonOnKeyboard()
    }
    
    private func setupView() {
        backgroundColor = Constants.Colors.backgroundColor
        layer.cornerRadius = Constants.Dimensions.cornerRadius
    }
    
    private func configureTitleLabel() {
        titleLabel.font = FontManager.shared.font(for: .commonInformation)
        titleLabel.textColor = Constants.Colors.titleTextColor
        titleLabel.textAlignment = .left
        addSubview(titleLabel)
    }
    
    private func configureTextField() {
        textField.font = FontManager.shared.font(for: .textField)
        textField.textColor = .black
        textField.alpha = 0
        textField.isHidden = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        addSubview(textField)
    }
    
    private func configureDeleteButton() {
        actionButton.tintColor = .black
        actionButton.contentHorizontalAlignment = .fill
        actionButton.contentVerticalAlignment = .fill
        actionButton.imageView?.contentMode = .scaleAspectFit
        actionButton.setImage(UIImage(systemName: Constants.Strings.deleteButtonImage), for: .normal)
        actionButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        actionButton.isHidden = true
        addSubview(actionButton)
    }
    
    private func addCloseButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let closeButton = UIBarButtonItem(title: Constants.Strings.closeButtonTitle,
                                          style: .done,
                                          target: self,
                                          action: #selector(closeInputView))
        toolbar.items = [flexSpace, closeButton]
        textField.inputAccessoryView = toolbar
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTitleLabel()
        layoutTextFieldAndDeleteButton()
    }
    
    private func layoutTitleLabel() {
        titleLabel.transform = .identity
        let padding = Constants.Dimensions.padding
        let labelSize = titleLabel.intrinsicContentSize
        let labelX = padding
        let labelY = (bounds.height - labelSize.height) / 2
        titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelSize.width, height: labelSize.height)
        
        if isActive {
            let scaledWidth = titleLabel.bounds.width * (1 - Constants.Dimensions.titleScale)
            let scaleTransform = CGAffineTransform(translationX: -scaledWidth / 2, y: Constants.Dimensions.titleTranslateY)
                .scaledBy(x: Constants.Dimensions.titleScale, y: Constants.Dimensions.titleScale)
            titleLabel.transform = scaleTransform
        }
    }
    
    private func layoutTextFieldAndDeleteButton() {
        let padding = Constants.Dimensions.padding
        
        if isActive {
            let textFieldY = titleLabel.frame.maxY - Constants.Dimensions.titleTranslateY
            textField.frame = CGRect(
                x: padding,
                y: textFieldY + (Constants.Dimensions.titleTranslateY - 3),
                width: bounds.width - 2 * padding - 25,
                height: Constants.Dimensions.textFieldHeight
            )
            
            actionButton.frame = CGRect(
                x: textField.frame.maxX + 1,
                y: textField.frame.minY,
                width: Constants.Dimensions.textFieldHeight,
                height: Constants.Dimensions.textFieldHeight
            )
        } else {
            textField.frame = .zero
            actionButton.frame = .zero
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: UIScreen.main.bounds.width - 2 * Common.Dimensions.horizontalMargin,
            height: Constants.Dimensions.searchBarHeight
        )
    }
    
    override var frame: CGRect {
        get { return super.frame }
        set {
            super.frame = CGRect(origin: newValue.origin, size: intrinsicContentSize)
        }
    }
    
    // MARK: - Actions
    @objc func didTapSearchBar() {
        let hasText = isEmty()
        guard !hasText else { return }
        
        isActive.toggle()
        if isActive {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        updateAppereance()
    }
    
    func isEmty() -> Bool {
        !(textField.text?.isEmpty ?? true)
    }
    
    func updateAppereance() {
        UIView.animate(withDuration: Constants.Dimensions.animationDuration, animations: {
            typealias constants = Constants.Dimensions
            self.setNeedsLayout()
            self.layoutIfNeeded()
            self.backgroundColor = self.isActive ? Constants.Colors.activeBackgroundColor : Constants.Colors.backgroundColor
            self.layer.borderWidth = self.isActive ? constants.activeBorderWidth : constants.activeBorderWidth
            self.layer.borderColor = self.isActive ? Constants.Colors.borderColor.cgColor : UIColor.clear.cgColor
            self.textField.alpha = self.isActive ? constants.activeBorderWidth : constants.activeBorderWidth
        }, completion: { _ in
            self.textField.isHidden = !self.isActive
        })
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let hasText = !(textField.text?.isEmpty ?? true)
        actionButton.isHidden = !hasText
        delegate?.action(self, textDidChange: textField.text ?? "")
        
        if !hasText && !textField.isFirstResponder {
            didTapSearchBar()
        }
    }
    
    @objc func didTapDeleteButton() {
        textField.text = ""
        textFieldDidChange(textField)
    }
    
    @objc func closeInputView() {
        textField.resignFirstResponder()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let touch = touches.first
        let point = touch?.location(in: self) ?? .zero
        if !actionButton.frame.contains(point) {
            textField.becomeFirstResponder()
        }
    }
}

// MARK: - UITextFieldDelegate
extension CustomTextField: UITextFieldDelegate {
    func setTextFieldType(_ keyboardType: UIKeyboardType = .default, _ textContentType: UITextContentType) {
        textField.keyboardType = keyboardType
        textField.textContentType = textContentType
    }
    
    func setTextFieldTarget(
        _ target: Any?,
        _ action: Selector =  #selector(textFieldDidChange),
        for event: UIControl.Event = .editingChanged
    ) {
        textField.removeTarget(nil, action: nil, for: .allEvents)
        textField.addTarget(target, action: action, for: event)
    }
    
    func setTextFieldInputView(_ inputView: UIView?) {
        textField.inputView = inputView
    }
    
    func setTextFieldText(_ text: String?) {
        textField.text = text
    }
    
    func setSecureTextEntry(_ isSecureTextEntry: Bool) {
        textField.isSecureTextEntry = isSecureTextEntry
    }
    
    func textFieldSendAction(for event: UIControl.Event) {
        textField.sendActions(for: event)
    }
    
    func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) {
        textField.isUserInteractionEnabled = isUserInteractionEnabled
    }
}

extension CustomTextField {
    func setActionButtonImage(_ image: UIImage?) {
        actionButton.setImage(image, for: .normal)
    }
    
    func setActionButtonTarget(
        _ target: Any?,
        _ action: Selector =  #selector(didTapDeleteButton),
        for event: UIControl.Event = .editingChanged
    ) {
        actionButton.removeTarget(nil, action: nil, for: .allEvents)
        actionButton.addTarget(target, action: action, for: event)
    }
    
    func addActionButtonTarget(
        _ target: Any?,
        _ action: Selector =  #selector(didTapDeleteButton),
        for event: UIControl.Event = .editingChanged
    ) {
        actionButton.addTarget(target, action: action, for: event)
    }
}

extension CustomTextField {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard !isActive else { return }
        isActive = true
        updateAppereance()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            isActive = false
            updateAppereance()
        }
    }
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        // TODO: - Отследить «вставку» пароля
        return true
    }
}
