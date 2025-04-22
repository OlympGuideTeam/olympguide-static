//
//  EnterPasswordViewController.swift
//  olympguide
//
//  Created by Tom Tim on 19.04.2025.
//

import UIKit
import AuthenticationServices

final class EnterPasswordViewController: UIViewController, NonTabBarVC {
    typealias Constants = AllConstants.EnterPasswordViewController
    typealias Common = AllConstants.Common
    
    // MARK: - VIP
    var interactor: EnterPasswordBusinessLogic?
    var router: EnterPasswordRoutingLogic?
    
    // MARK: - UI
    var passwordTextField: HighlightableField = CustomPasswordField(with: "Придумайте пароль")
    private let emailTextField: UITextField = UITextField()
    
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
    private var currentPassword: String = ""
    
    init(email: String) {
        super.init(nibName: nil, bundle: nil)
        emailTextField.text = email
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        if let navigationController = self.navigationController {
            let viewControllers = navigationController.viewControllers
            if let rootViewController = viewControllers.first {
                navigationController.setViewControllers([rootViewController, self], animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.didTapSearchBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        navigationController?.navigationBar.backgroundColor = .clear
        if self.isMovingFromParent {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    // MARK: - Private UI Setup
    private func configureUI() {
        view.backgroundColor = Constants.Colors.background
        configurePasswordTextField()
        configureEmailTextField()
//        configureRepeatPasswordTextField()
        configureNextButton()
    }
    
//    private func configurePasswordTextField() {
//        view.addSubview(passwordTextField)
//        
//        passwordTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.passwordTextFieldTopPadding)
//        passwordTextField.pinLeft(to: view.leadingAnchor, Constants.Dimensions.horizontalMargin)
//        passwordTextField.textField.textContentType = .newPassword
//        passwordTextField.textField.passwordRules = UITextInputPasswordRules(descriptor: "required: upper; required: lower; required: digit; max-consecutive: 2; minlength: 8;")
//        passwordTextField.textField.autocorrectionType = .no
//        passwordTextField.textField.autocapitalizationType = .none
//        passwordTextField.delegate = self
//        passwordTextField.tag = 1
//    }
    
    private func configurePasswordTextField() {
        view.addSubview(passwordTextField)

        passwordTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.passwordTextFieldTopPadding)
        passwordTextField.pinLeft(to: view.leadingAnchor, Constants.Dimensions.horizontalMargin)
        passwordTextField.textField.textContentType = .newPassword
        passwordTextField.textField.passwordRules = UITextInputPasswordRules(descriptor: "required: upper; required: lower; required: digit; max-consecutive: 2; minlength: 8;")
        passwordTextField.textField.keyboardType = .asciiCapable
        passwordTextField.textField.autocorrectionType = .no
        passwordTextField.textField.autocapitalizationType = .none
        passwordTextField.delegate = self
        passwordTextField.tag = 1
    }

    
    private func configureEmailTextField() {
        view.addSubview(emailTextField)
        emailTextField.textContentType = .username
        emailTextField.isEnabled = false
        emailTextField.isHidden = false
        emailTextField.alpha = 0.01
        emailTextField.textColor = .white
        emailTextField.pinTop(to: passwordTextField.bottomAnchor, 10)
        emailTextField.pinLeft(to: view.leadingAnchor, 20)
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
        let request = EnterPassword.SignUp.Request(
            email: emailTextField.text ?? "",
            password: currentPassword
        )
        interactor?.signUp(with: request)
    }
}

// MARK: - CustomTextFieldDelegate
extension EnterPasswordViewController: CustomTextFieldDelegate {
    func action(_ searchBar: CustomTextField, textDidChange text: String) {
        currentPassword = text
    }
}

// MARK: - Keyboard handling
extension EnterPasswordViewController {
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
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            let keyboardHeight = keyboardFrame.height
            nextButtonBottomConstraint?.constant = -keyboardHeight - Constants.Dimensions.keyboardBottomPadding
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            nextButtonBottomConstraint?.constant = -Constants.Dimensions.nextButtonBottomPadding
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - EnterEmailDisplayLogic
extension EnterPasswordViewController: EnterPasswordDisplayLogic {
    func displaySignUpResult(with viewModel: EnterPassword.SignUp.ViewModel) {
        let credential = ASPasswordCredential(user: emailTextField.text ?? "", password: currentPassword)
        let authController = ASCredentialProviderViewController()
        authController.extensionContext.completeRequest(withSelectedCredential: credential, completionHandler: nil)
        router?.routeToRoot()
    }
}
