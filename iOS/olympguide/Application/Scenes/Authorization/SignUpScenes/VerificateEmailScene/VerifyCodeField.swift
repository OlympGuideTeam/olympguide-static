//
//  VerifyCodeField.swift
//  olympguide
//
//  Created by Tom Tim on 22.01.2025.
//

import UIKit
// MARK: - Constants
fileprivate enum Constants {
    static let keyPath: String = "position"
    static let duration: CFTimeInterval = 0.09
    static let repeatCount: Float = 2
    static let shift: CGFloat = 3
    static let colorDuration: CFTimeInterval = 0.1
}

final class VerifyCodeField: UIView, UIKeyInput {
    private let hiddenTextField = CustomTextFeield()
    
    var onComplete: ((String) -> Void)?
    
    private let digitCount: Int = 4
    private var digits: [Character] = []
    private var digitLabels: [UILabel] = []
    
    // MARK: - Инициализаторы
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: 230,
            height: 50
        )
    }
    
    override var frame: CGRect {
        get { return super.frame }
        set {
            super.frame = CGRect(
                origin: newValue.origin,
                size: self.intrinsicContentSize
            )
        }
    }
    
    // MARK: - Настройка внешнего вида
    private func setupView() {
        hiddenTextField.keyboardType = .numberPad
        hiddenTextField.isHidden = true
        hiddenTextField.newDelegate = self
        hiddenTextField.delegate = self
        addSubview(hiddenTextField)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        
        addSubview(stackView)
        
        stackView.pinTop(to: topAnchor)
        stackView.pinBottom(to: bottomAnchor)
        stackView.pinLeft(to: leadingAnchor)
        stackView.pinRight(to: trailingAnchor)
        
        for _ in 0..<digitCount {
            let label = UILabel()
            label.backgroundColor = .white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 24)
            label.layer.cornerRadius = 8
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.black.cgColor
            label.clipsToBounds = true
            
            stackView.addArrangedSubview(label)
            digitLabels.append(label)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    func setFocusToFirstField() {
        handleTap()
    }
    
    func clear() {
        UIView.animate(withDuration: Constants.colorDuration) {
            self.digitLabels.forEach {
                $0.backgroundColor = .white
            }
        }
        digits.removeAll()
        updateLabels()
        setFocusToFirstField()
    }
    
    @objc private func handleTap() {
        hiddenTextField.becomeFirstResponder()
    }
    
    
    func shakeAndChangeColor() {
        let shakeAnimation = CABasicAnimation(keyPath: Constants.keyPath)
        shakeAnimation.duration = Constants.duration
        shakeAnimation.repeatCount = Constants.repeatCount
        shakeAnimation.autoreverses = true
        shakeAnimation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - Constants.shift, y: self.center.y))
        shakeAnimation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + Constants.shift, y: self.center.y))
        
        self.layer.add(shakeAnimation, forKey: Constants.keyPath)
        UIView.animate(withDuration: Constants.colorDuration, animations: {
            self.digitLabels.forEach {
                $0.backgroundColor = UIColor(hex: "FFCDCD")
            }
        }) { _ in
//            self.clear()
        }
    }
    
    // MARK: - Обновление UI (отображение цифр)
    private func updateLabels() {
        for i in 0..<digitCount {
            if i < digits.count {
                digitLabels[i].text = String(digits[i])
                UIView.animate(withDuration: 0.2) {[weak self] in
                    self?.digitLabels[i].layer.borderWidth = 2
                }
            } else {
                digitLabels[i].text = ""
                UIView.animate(withDuration: 0.2) {[weak self] in
                    self?.digitLabels[i].layer.borderWidth = 1
                }
            }
        }
    }
    
    // MARK: - UIKeyInput
    var hasText: Bool {
        !digits.isEmpty
    }
    
    func insertText(_ text: String) {
        guard text.count == 1,
              let char = text.first,
              char.isNumber
        else {
            return
        }
        
        guard digits.count < digitCount else {
            return
        }
        
        digits.append(char)
        updateLabels()
        
        if digits.count == digitCount {
            onComplete?(String(digits))
            
            hiddenTextField.resignFirstResponder()
        }
    }
    
    func deleteBackward() {
        guard !digits.isEmpty else { return }
        if digitLabels[0].backgroundColor == UIColor(hex: "FFCDCD") {
            UIView.animate(withDuration: 0.2) {[weak self] in
                self?.digitLabels.forEach {
                    $0.backgroundColor = .white
                }
            }
        }
        digits.removeLast()
        updateLabels()
    }
    
    private var keyboardType: UIKeyboardType {
        .numberPad
    }
}


// MARK: - UITextFieldDelegate
extension VerifyCodeField : UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        insertText(string)
        return false
    }
}


class CustomTextFeield: UITextField {
    var newDelegate: UIKeyInput?
    
    override var hasText: Bool {
        newDelegate?.hasText ?? false
    }
    
    override func deleteBackward() {
        newDelegate?.deleteBackward()
    }
}
