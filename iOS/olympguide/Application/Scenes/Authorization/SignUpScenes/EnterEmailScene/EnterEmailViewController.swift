//
//  EnterEmailViewController.swift
//  olympguide
//
//  Created by Tom Tim on 19.01.2025.
//

import UIKit

final class EnterEmailViewController: UIViewController, NonTabBarVC {
    typealias Constants = AllConstants.EnterEmailViewController
    typealias Common = AllConstants.Common
    
    // MARK: - VIP
    var interactor: EnterEmailBusinessLogic?
    var router: (EnterEmailRoutingLogic & EnterEmailDataPassing)?
    
    // MARK: - UI
    private let emailTextField: CustomInputDataField = CustomInputDataField(with: "email")
    private let nextButton: UIButton = UIButton(type: .system)
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
    
    // MARK: - Actions
    @objc
    private func didTapNextButton() {
        let request = EnterEmailModels.SendCode.Request(email: currentEmail)
        interactor?.sendCode(with: request)
    }
}

extension EnterEmailViewController: CustomTextFieldDelegate {
    func action(_ searchBar: CustomTextField, textDidChange text: String) {
        currentEmail = text
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

