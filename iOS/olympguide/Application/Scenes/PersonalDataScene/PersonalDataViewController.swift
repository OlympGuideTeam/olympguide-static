//
//  PersonalDataScene.swift
//  olympguide
//
//  Created by Tom Tim on 22.01.2025.
//

import UIKit
import AuthenticationServices

final class PersonalDataViewController: UIViewController, ValidationErrorDisplayable, NonTabBarVC {
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    // MARK: - Свойства
    private var token: String = ""
    private var hasSecondName: Bool = true
        
    private var toggleButtonTopConstraint: NSLayoutConstraint?
    private var birthdayTopConstraint: NSLayoutConstraint?
    
    private let user: UserViewModel
    
    var interactor: PersonalDataInteractor?
    var router: PersonalDataRouter?
    
    // MARK: UI Элементы
    let lastNameTextField: CustomInputDataField = CustomInputDataField(with: "Фамилия")
    let nameTextField: CustomInputDataField = CustomInputDataField(with: "Имя")
    
    var secondNameTextField: CustomInputDataField = CustomInputDataField(with: "Отчество")
    
    let toggleSecondNameButton: HasSecondNameButton = HasSecondNameButton(frame: .zero)
    
    let birthdayPicker: CustomDatePicker = CustomDatePicker(with: "День рождения")
    
    let regionTextField = OptionsTextField(
        with: "Регион",
        filterItem: FilterItem(
            paramType: .region,
            title: "Регион",
            initMethod: .endpoint("/meta/regions"),
            isMultipleChoice: true
        )
    )
    
    let passwordTextField: CustomPasswordField = CustomPasswordField(with: "Придумайте пароль")
    
    private let nextButton: UIButton = UIButton(type: .system)
    private let changePasswordButton: UIButton = UIButton(type: .system)
    private let changePasswordText: UITextView = {
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
    
    // MARK: Свойства данных
    var lastName: String = ""
    var firstName: String = ""
    var secondName: String = ""
    var birthday: String = ""
    var region: Int?
    var password: String = ""
    
    init(with user: UserViewModel) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Личные данные"
        
        configureUI()
        
        toggleSecondNameButton.addTarget(self, action: #selector(toggleSecondNameTapped), for: .touchUpInside)
        
        lastNameTextField.delegate = self
        nameTextField.delegate = self
        secondNameTextField.delegate = self
        birthdayPicker.delegate = self
        passwordTextField.delegate = self
        
        nameTextField.tag = 1
        secondNameTextField.tag = 2
        lastNameTextField.tag = 3
        birthdayPicker.tag = 4
        regionTextField.tag = 5
        passwordTextField.tag = 6
        
        if let navigationController = self.navigationController {
            let viewControllers = navigationController.viewControllers
            if let rootViewController = viewControllers.first {
                navigationController.setViewControllers([rootViewController, self], animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.backgroundColor = .white
//        if user.secondName == "" {
//            UIView.performWithoutAnimation {
//                toggleSecondNameTapped()
//            }
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.backgroundColor = .clear
        if self.isMovingFromParent {
            navigationController?.popToRootViewController(animated: true)
        }
    }
        
    
    // MARK: - Настройка UI
    private func configureUI() {
        // 1. Фамилия
        configureLastNameTextField()
        // 2. Имя
        configureNameTextField()
        // 3. Отчество (если включено)
        configureSecondNameTextField()
        // 4. Кнопка для переключения поля «Отчество»
        configureToggleSecondNameButton()
        // 5. День рождения
        configureBirthdayPicker()
        // 6. Регион
        configureRegionTextField()
        // 7. Пароль
        configureNextButton()
        configureChangePasswordButton()
        
        let hiddenUsernameField = UITextField(frame: .zero)
        hiddenUsernameField.text = token
        hiddenUsernameField.textContentType = .username
        hiddenUsernameField.isHidden = true
        view.addSubview(hiddenUsernameField)
        
    
    }
        
    private func configureLastNameTextField() {
        view.addSubview(lastNameTextField)
        
        lastNameTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 16)
        lastNameTextField.pinLeft(to: view.leadingAnchor, 20)
        
        if let lastName = user.lastName {
            lastNameTextField.setTextFieldText(lastName)
            lastNameTextField.isActive = true
            lastNameTextField.isHidden = false
            lastNameTextField.textFieldDidChange(lastNameTextField.textField)
            UIView.performWithoutAnimation {
                
                lastNameTextField.updateAppereance()
            }
            self.lastName = lastName
//            lastNameTextField.textField.text = lastName
////            lastNameTextField.didTapSearchBar()
//            lastNameTextField.textFieldDidChange(lastNameTextField.textField)
//            lastNameTextField.setTitle(to: lastName)
        }
    }
    
    private func configureNameTextField() {
        view.addSubview(nameTextField)
        
        nameTextField.pinTop(to: lastNameTextField.bottomAnchor, 24)
        nameTextField.pinLeft(to: view.leadingAnchor, 20)
        
        if let firstName = user.firstName {
            nameTextField.setTextFieldText(firstName)
            nameTextField.isActive = true
            nameTextField.isHidden = false
            nameTextField.textFieldDidChange(nameTextField.textField)
            UIView.performWithoutAnimation {
                
                nameTextField.updateAppereance()
            }
            self.firstName = firstName
//            nameTextField.setTitle(to: firstName)
        }
    }
    
    private func configureSecondNameTextField() {
        view.addSubview(secondNameTextField)
        
        secondNameTextField.pinTop(to: nameTextField.bottomAnchor, 24)
        secondNameTextField.pinLeft(to: view.leadingAnchor, 20)
        
        if let secondName = user.secondName, secondName.count > 0 {
            secondNameTextField.setTextFieldText(secondName)
            secondNameTextField.isActive = true
            secondNameTextField.isHidden = false
            
            secondNameTextField.textFieldDidChange(secondNameTextField.textField)
            UIView.performWithoutAnimation {
                
                secondNameTextField.updateAppereance()
            }
            self.secondName = secondName
            
            //            secondNameTextField.setTitle(to: secondName)
        }
    }
    
    private func configureToggleSecondNameButton() {
        view.addSubview(toggleSecondNameButton)
        toggleSecondNameButton.text = "Нет отчества"
        
        toggleSecondNameButton.translatesAutoresizingMaskIntoConstraints = false
        hasSecondName = user.secondName != ""
        if hasSecondName {
            toggleButtonTopConstraint = toggleSecondNameButton.topAnchor.constraint(
                equalTo: secondNameTextField.bottomAnchor,
                constant: 24
            )
        } else {
            toggleButtonTopConstraint = toggleSecondNameButton.topAnchor.constraint(
                equalTo: nameTextField.bottomAnchor,
                constant: 24
            )
            secondNameTextField.isHidden = true
        }
        toggleButtonTopConstraint?.isActive = true
        
        toggleSecondNameButton.pinLeft(to: view.leadingAnchor)
        toggleSecondNameButton.pinRight(to: view.trailingAnchor)
    }
    
    private func configureBirthdayPicker() {
        view.addSubview(birthdayPicker)
        birthdayPicker.translatesAutoresizingMaskIntoConstraints = false
        birthdayTopConstraint = birthdayPicker.topAnchor.constraint(equalTo: toggleSecondNameButton.bottomAnchor, constant: 24)
        birthdayTopConstraint?.isActive = true
        
        birthdayPicker.pinLeft(to: view.leadingAnchor, 20)
        
        if let birthday = user.birthday {
            birthdayPicker.setTextFieldText(birthday)
            birthdayPicker.isActive = true
            birthdayPicker.isHidden = false
            
            birthdayPicker.textFieldDidChange(birthdayPicker.textField)
            UIView.performWithoutAnimation {
                birthdayPicker.updateAppereance()
            }
            self.birthday = birthday
        }
        
    }
    
    private func configureRegionTextField() {
        view.addSubview(regionTextField)
        
        regionTextField.pinTop(to: birthdayPicker.bottomAnchor, 24)
        regionTextField.pinLeft(to: view.leadingAnchor, 20)
        
        regionTextField.regionDelegate = self
        
        if let region = user.region {
            regionTextField.setTextFieldText(region.name)
            regionTextField.isActive = true
            regionTextField.isHidden = false
            
            regionTextField.textFieldDidChange(regionTextField.textField)
            UIView.performWithoutAnimation {
                regionTextField.updateAppereance()
            }
            self.region = region.regionId
        }
    }
    
    private func configurePasswordTextField() {
        view.addSubview(passwordTextField)
        
        passwordTextField.pinTop(to: regionTextField.bottomAnchor, 24)
        passwordTextField.pinLeft(to: view.leadingAnchor, 20)
        
        passwordTextField.setTextFieldType(.default, .newPassword)
    }
    
    private func configureChangePasswordButton() {
        changePasswordButton.titleLabel?.font = FontManager.shared.font(for: .bigButton)
        changePasswordButton.layer.cornerRadius = 13
        changePasswordButton.titleLabel?.tintColor = .black
        changePasswordButton.backgroundColor = UIColor(hex: "#E0E8FE")
        changePasswordButton.setTitle("Изменить пароль", for: .normal)
        
        view.addSubview(changePasswordButton)
        
        changePasswordButton.setHeight(48)
        changePasswordButton.pinTop(to: regionTextField.bottomAnchor, 20, .grOE)
        changePasswordButton.pinLeft(to: view.leadingAnchor, 20)
        changePasswordButton.pinRight(to: view.trailingAnchor, 20)
        changePasswordButton.pinBottom(to: nextButton.topAnchor, 10)
        changePasswordButton.addTarget(self, action: #selector(didTapChangePasswordButton), for: .touchUpInside)
    }
    
    private func configureNextButton() {
        nextButton.titleLabel?.font = FontManager.shared.font(for: .bigButton)
        nextButton.layer.cornerRadius = 13
        nextButton.titleLabel?.tintColor = .black
        nextButton.backgroundColor = UIColor(hex: "#E0E8FE")
        nextButton.setTitle("Сохранить", for: .normal)
        
        view.addSubview(nextButton)
        
        nextButton.setHeight(48)
        nextButton.pinLeft(to: view.leadingAnchor, 20)
        nextButton.pinRight(to: view.trailingAnchor, 20)
//        nextButton.pinBottom(to: view.bottomAnchor, 10)
        nextButton.pinBottom(to: view.bottomAnchor, 43, .grOE)
        
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    private func configureAgreementTextView() {
        view.addSubview(changePasswordText)
        
//        changePasswordText.delegate = self
        
        let fullText = "Изменить пароль"
        let attributedText = NSMutableAttributedString(string: fullText)
        
        if let termsRange = fullText.range(of: "Изменить пароль"){
            let nsTermsRange = NSRange(termsRange, in: fullText)
            
            attributedText.addAttribute(.link, value: "https://olympguide.ru/terms", range: nsTermsRange)
        }
        
        attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, attributedText.length))
        attributedText.addAttribute(.foregroundColor, value: UIColor.gray, range: NSMakeRange(0, attributedText.length))
        
        changePasswordText.attributedText = attributedText
        
        changePasswordText.pinLeft(to: view.leadingAnchor, 20)
        changePasswordText.pinRight(to: view.trailingAnchor, 20)
        changePasswordText.pinBottom(to: nextButton.topAnchor, 10)
    }
    
    // MARK: - Переключение поля «Отчество»
    @objc private func toggleSecondNameTapped() {
        if hasSecondName {
            hasSecondName = false
            secondNameTextField.isHidden = true
            
            toggleButtonTopConstraint?.isActive = false
            toggleButtonTopConstraint = toggleSecondNameButton.topAnchor.constraint(
                equalTo: nameTextField.bottomAnchor,
                constant: 24
            )
            toggleButtonTopConstraint?.isActive = true
            toggleSecondNameButton.setImage(UIImage(systemName: "inset.filled.circle"), for: .normal)
        } else {
            hasSecondName = true
            view.addSubview(secondNameTextField)
            secondNameTextField.isHidden = false
            
            toggleButtonTopConstraint?.isActive = false
            toggleButtonTopConstraint = toggleSecondNameButton.topAnchor.constraint(
                equalTo: secondNameTextField.bottomAnchor,
                constant: 24
            )
            toggleButtonTopConstraint?.isActive = true
            toggleSecondNameButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.view.layoutIfNeeded()
            self?.secondNameTextField.alpha = self?.hasSecondName ?? false ? 1 : 0
        }
    }
    
    // MARK: - Keyboard Handling
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        // Высота клавиатуры
        let keyboardHeight = keyboardFrame.height
        
        // Ищем текущий firstResponder (какое поле сейчас редактируется)
        if let activeField = view.currentFirstResponder() as? UIView {
            // координата Y нижнего края поля ввода внутри self.view
            let bottomOfTextField = activeField.convert(activeField.bounds, to: self.view).maxY
            
            // Верх клавиатуры относительно self.view
            let topOfKeyboard = self.view.frame.height - keyboardHeight
            
            // Если поле уходит ниже клавиатуры, поднимаем экран
            if bottomOfTextField > topOfKeyboard {
                let offset = bottomOfTextField - topOfKeyboard + 10
                self.view.frame.origin.y = -offset
            } else {
                self.view.frame.origin.y = 0
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    // MARK: - Actions
    @objc private func didTapNextButton() {
        let request = PersonalData.SignUp.Request(
            firstName: firstName,
            lastName: lastName,
            secondName: hasSecondName ? secondName : nil,
            birthday: birthday,
            regionId: region,
        )
        interactor?.signUp(with: request)
    }
    
    @objc private func didTapChangePasswordButton() {
        interactor?.sendCode(with: PersonalData.SendCode.Request())
    }
}

// MARK: - Делегаты для кастомных текстовых полей
extension PersonalDataViewController: CustomTextFieldDelegate {
    func action(_ searchBar: UIView, textDidChange text: String) {
        switch searchBar.tag {
        case 1:
            firstName = text
        case 2:
            secondName = text
        case 3:
            lastName = text
        case 4:
            birthday = text
        case 6:
            password = text
        default:
            break
        }
    }
}

extension PersonalDataViewController: OptionsTextFieldDelegate {
    func regionTextFieldDidSelect(option: OptionViewModel) {
        self.region = option.id
    }
    
    func textWasDeleted(tag: Int) {
        self.region = nil
    }
    
    func regionTextFieldWillSelect(with optionsVC: OptionsViewController) {
        optionsVC.modalPresentationStyle = .overFullScreen
        present(optionsVC, animated: false)
    }
    
    func dissmissKeyboard() {
        view.endEditing(true)
    }
}

extension PersonalDataViewController : PersonalDataDisplayLogic {
    func displaySendCodeResult(with viewModel: PersonalData.SendCode.ViewModel) {
        router?.routeToVerifyCode()
    }
    
    func displaySignUp(with viewModel: PersonalData.SignUp.ViewModel) {
        if let errorMesseges = viewModel.errorMessage {
            showAlert(with: errorMesseges.joined(separator: "\n"))
            return
        }
        router?.routeToRoot()
    }
}
