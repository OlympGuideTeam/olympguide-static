//
//  SignInViewController.swift
//  olympguide
//
//  Created by Tom Tim on 19.02.2025.
//

import UIKit
import AuthenticationServices

final class SignInViewController: UIViewController, SignInValidationErrorDisplayable, NonTabBarVC {
    typealias Constants = AllConstants.SignInViewController
    
    // MARK: - VIP
    var interactor: SignInBusinessLogic?
    var router: SignInRoutingLogic?
    
    // MARK: - UI
    let emailTextField: CustomInputDataField = CustomInputDataField(with: Constants.Strings.emailPlaceholder)
    let passwordTextField: CustomPasswordField = CustomPasswordField(with: Constants.Strings.passwordPlaceholder)
    
    private let nextButton: UIButton = UIButton(type: .system)
    private var nextButtonBottomConstraint: NSLayoutConstraint?
    private var email: String = ""
    private var password: String = ""
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.Strings.title
        
        emailTextField.tag = 1
        passwordTextField.tag = 2
        
        configureUI()
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
        view.backgroundColor = .white
        configureEmailTextField()
        configurePasswordTextField()
        configureNextButton()
    }
    
    private func configureEmailTextField() {
        view.addSubview(emailTextField)
        
        emailTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.Dimensions.emailTextFieldTop)
        emailTextField.pinLeft(to: view.leadingAnchor, Constants.Dimensions.emailTextFieldLeft)
        emailTextField.setTextFieldType(.emailAddress, .username)
        emailTextField.delegate = self
    }
    
    private func configurePasswordTextField() {
        view.addSubview(passwordTextField)
        
        passwordTextField.pinTop(to: emailTextField.bottomAnchor, Constants.Dimensions.passwordTextFieldTop)
        passwordTextField.pinLeft(to: view.leadingAnchor, Constants.Dimensions.passwordTextFieldLeft)
        passwordTextField.setTextFieldType(.default, .password)
        passwordTextField.delegate = self
    }
    
    private func configureNextButton() {
        nextButton.titleLabel?.font = FontManager.shared.font(for: .bigButton)
        nextButton.layer.cornerRadius = Constants.Dimensions.nextButtonCornerRadius
        nextButton.titleLabel?.tintColor = Constants.Colors.nextButtonText
        nextButton.backgroundColor = UIColor(hex: Constants.Colors.nextButtonBackground)
        nextButton.setTitle(Constants.Strings.nextButtonTitle, for: .normal)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        
        nextButton.setHeight(Constants.Dimensions.nextButtonHeight)
        nextButton.pinLeft(to: view.leadingAnchor, Constants.Dimensions.emailTextFieldLeft)
        nextButton.pinRight(to: view.trailingAnchor, Constants.Dimensions.emailTextFieldLeft)
        
        nextButtonBottomConstraint = nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Constants.Dimensions.nextButtonBottomOffsetDefault)
        nextButtonBottomConstraint?.isActive = true
        
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc
    private func didTapNextButton() {
        let request = SignInModels.SignIn.Request(email: email, password: password)
        interactor?.signIn(with: request)
    }
}

extension SignInViewController: CustomTextFieldDelegate {
    func action(_ searchBar: UIView, textDidChange text: String) {
        switch searchBar.tag {
        case 1:
            email = text
        case 2:
            password = text
        default:
            break
        }
    }
}

// MARK: - Keyboard handling
extension SignInViewController {
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
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
           let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            let keyboardHeight = keyboardFrame.height
            nextButtonBottomConstraint?.constant = -keyboardHeight + Constants.Dimensions.nextButtonBottomOffsetKeyboard
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func keyboardWillHide(notification: Notification) {
        if let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            nextButtonBottomConstraint?.constant = Constants.Dimensions.nextButtonBottomOffsetDefault
            
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension SignInViewController : SignInDisplayLogic {
    func displaySignInResult(with viewModel: SignInModels.SignIn.ViewModel) {
        if viewModel.success {
                let credential = ASPasswordCredential(user: email, password: password)
                let authController = ASCredentialProviderViewController()
                authController.extensionContext.completeRequest(withSelectedCredential: credential, completionHandler: nil)

                router?.routeToRoot()
            } else if let errorMessages = viewModel.errorMessages, !errorMessages.isEmpty {
                showAlert(with: errorMessages.joined(separator: "\n"))
            }
    }
}
