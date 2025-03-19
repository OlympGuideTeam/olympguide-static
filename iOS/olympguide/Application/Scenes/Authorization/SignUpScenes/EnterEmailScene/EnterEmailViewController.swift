//
//  EnterEmailViewController.swift
//  olympguide
//
//  Created by Tom Tim on 19.01.2025.
//

import UIKit
import SafariServices

final class EnterEmailViewController: UIViewController, NonTabBarVC {
    typealias Constants = AllConstants.EnterEmailViewController
    typealias Common = AllConstants.Common
    
    // MARK: - VIP
    var interactor: EnterEmailBusinessLogic?
    var router: (EnterEmailRoutingLogic & EnterEmailDataPassing)?
    
    // MARK: - UI
    private let emailTextField: CustomInputDataField = CustomInputDataField(with: "email")
    private let nextButton: UIButton = UIButton(type: .system)
    
    private let agreementTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.textAlignment = .center
        tv.dataDetectorTypes = .link
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        return tv
    }()
    
    private var nextButtonBottomConstraint: NSLayoutConstraint?
    private var currentEmail: String = ""
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.Strings.title
        configureUI()
        let backItem = UIBarButtonItem(
            title: Constants.Strings.title,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.didTapSearchBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: - Private UI Setup
    private func configureUI() {
        view.backgroundColor = Constants.Colors.background
        configureEmailTextField()
        configureNextButton()
        configureAgreementTextView()
    }
    
    private func configureEmailTextField() {
        view.addSubview(emailTextField)
        
        emailTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.emailTextFieldTopPadding)
        emailTextField.pinLeft(to: view.leadingAnchor, Constants.Dimensions.horizontalMargin)
        emailTextField.setTextFieldType(.emailAddress, .emailAddress)
        emailTextField.delegate = self
    }
    
    private func configureNextButton() {
        nextButton.titleLabel?.font = FontManager.shared.font(for: .bigButton)
        nextButton.layer.cornerRadius = Constants.Dimensions.nextButtonCornerRadius
        nextButton.titleLabel?.tintColor = Constants.Colors.nextButtonText
        nextButton.backgroundColor = Constants.Colors.nextButtonBackground
        nextButton.setTitle(Constants.Strings.nextButtonTitle, for: .normal)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        
        nextButton.setHeight(Constants.Dimensions.nextButtonHeight)
        nextButton.pinLeft(to: view.leadingAnchor, Constants.Dimensions.horizontalMargin)
        nextButton.pinRight(to: view.trailingAnchor, Constants.Dimensions.horizontalMargin)
        
        nextButtonBottomConstraint = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.Dimensions.nextButtonBottomPadding)
        nextButtonBottomConstraint?.isActive = true
        
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    private func configureAgreementTextView() {
        view.addSubview(agreementTextView)
        
        agreementTextView.delegate = self
        
        let fullText = "Нажимая «Продолжить», вы соглашаетесь с Условиями использования и Политикой конфиденциальности"
        let attributedText = NSMutableAttributedString(string: fullText)
        
        if let termsRange = fullText.range(of: "Условиями использования"),
           let privacyRange = fullText.range(of: "Политикой конфиденциальности") {
            let nsTermsRange = NSRange(termsRange, in: fullText)
            let nsPrivacyRange = NSRange(privacyRange, in: fullText)
            
            attributedText.addAttribute(.link, value: "https://olympguide.ru/terms", range: nsTermsRange)
            attributedText.addAttribute(.link, value: "https://olympguide.ru/privacy", range: nsPrivacyRange)
        }
        
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, attributedText.length))
        attributedText.addAttribute(.foregroundColor, value: UIColor.gray, range: NSMakeRange(0, attributedText.length))
        
        agreementTextView.attributedText = attributedText
        
        agreementTextView.pinLeft(to: view.leadingAnchor, Constants.Dimensions.horizontalMargin)
        agreementTextView.pinRight(to: view.trailingAnchor, Constants.Dimensions.horizontalMargin)
        agreementTextView.pinBottom(to: nextButton.topAnchor, 10)
    }
    
    // MARK: - Actions
    @objc
    private func didTapNextButton() {
        let request = EnterEmailModels.SendCode.Request(email: currentEmail)
        interactor?.sendCode(with: request)
    }
}

// MARK: - CustomTextFieldDelegate
extension EnterEmailViewController: CustomTextFieldDelegate {
    func action(_ searchBar: CustomTextField, textDidChange text: String) {
        currentEmail = text
    }
}

// MARK: - UITextViewDelegate
extension EnterEmailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let safariVC = SFSafariViewController(url: URL)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true, completion: nil)
        return false
    }
}

// MARK: - Keyboard handling
extension EnterEmailViewController {
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            let keyboardHeight = keyboardFrame.height
            nextButtonBottomConstraint?.constant = -keyboardHeight - Constants.Dimensions.keyboardBottomPadding
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        if let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            nextButtonBottomConstraint?.constant = -Constants.Dimensions.nextButtonBottomPadding
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - EnterEmailDisplayLogic
extension EnterEmailViewController: EnterEmailDisplayLogic {
    func displaySendCodeResult(with viewModel: EnterEmailModels.SendCode.ViewModel) {
        router?.routeToVerifyCode()
    }
}
