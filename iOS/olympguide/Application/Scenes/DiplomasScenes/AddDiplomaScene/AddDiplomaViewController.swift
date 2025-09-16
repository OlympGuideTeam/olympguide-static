//
//  AddDiplomaViewController.swift
//  olympguide
//
//  Created by Tom Tim on 25.03.2025.
//

import UIKit

final class AddDiplomaViewController : UIViewController, NonTabBarVC {
    typealias Common = AllConstants.Common
    private let nextButton: UIButton = UIButton(type: .system)

    var interactor: AddDiplomaBusinessLogic?
    var router: AddDiplomaRoutingLogic?
    
    private let olympiad: OlympiadModel
    
    private let informationStackView: UIStackView = UIStackView()
    
    var classTextField: OptionsTextField = OptionsTextField(
        with: "Класс диплома",
        filterItem: FilterItem(
            paramType: .minClass,
            title: "Класс диплома",
            initMethod: .models([
                OptionViewModel(id: 10, name: "10 класс"),
                OptionViewModel(id: 11, name: "11 класс")
            ]),
            isMultipleChoice: false
        )
    )
    
    var diplomaLevelTextField: OptionsTextField = OptionsTextField(
        with: "Степень диплома",
        filterItem: FilterItem(
            paramType: .minDiplomaLevel,
            title: "Степень диплома",
            initMethod: .models([
                OptionViewModel(id: 1, name: "Победитель"),
                OptionViewModel(id: 3, name: "Призёр")
            ]),
            isMultipleChoice: false
        )
    )
    
    private var diplomaClass: Int?
    private var diplomaLevel: Int?
    
    init(with olympiad: OlympiadModel) {
        self.olympiad = olympiad
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        title = "Диплом"
        navigationItem.largeTitleDisplayMode = .always

        view.backgroundColor = .white
        configureInformationStackView()
        configureOlympiadNameLabel()
        configureOlympiadInformation()
        
        configureClassTextField()
        configureLevelTextField()
        
        configureNextButton()
    }
    
    private func configureOlympiadNameLabel() {
        let olympiadNameLabel = UILabel()
        olympiadNameLabel.font = FontManager.shared.font(weight: .medium, size: 17.0)
        olympiadNameLabel.numberOfLines = 0
        olympiadNameLabel.lineBreakMode = .byWordWrapping
        olympiadNameLabel.text = olympiad.name
        
        olympiadNameLabel.calculateHeight()
        informationStackView.addArrangedSubview(olympiadNameLabel)
    }
    
    private func configureInformationStackView() {
        informationStackView.arrangedSubviews.forEach { informationStackView.removeArrangedSubview($0) }
        informationStackView.axis = .vertical
        informationStackView.spacing = 17
        informationStackView.distribution = .fill
        informationStackView.alignment = .leading
        
        informationStackView.isLayoutMarginsRelativeArrangement = true
        informationStackView.layoutMargins = UIEdgeInsets(
            top: 15,
            left: 20,
            bottom: 0,
            right: 20
        )
        
        view.addSubview(informationStackView)
        
        informationStackView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        informationStackView.pinLeft(to: view.leadingAnchor)
        informationStackView.pinRight(to: view.trailingAnchor)
    }
    
    private func configureOlympiadInformation() {
        let olympiadInformationStack = UIStackView()
        
        olympiadInformationStack.axis = .vertical
        olympiadInformationStack.spacing = 7
        olympiadInformationStack.distribution = .fill
        olympiadInformationStack.alignment = .fill
        
        olympiadInformationStack.addArrangedSubview(configureLevelLabel())
        olympiadInformationStack.addArrangedSubview(configureProfileLabel())
        
        informationStackView.addArrangedSubview(olympiadInformationStack)
    }
    
    private func configureLevelLabel() -> UILabel {
        let levelLabel = UILabel()
        levelLabel.font = FontManager.shared.font(for: .additionalInformation)
        levelLabel.textColor = Common.Colors.additionalText
        levelLabel.text = "Уровень: " + String(repeating: "I", count: olympiad.level)
        
        return levelLabel
    }
    
    private func configureProfileLabel() -> UILabel {
        let profileLabel = UILabel()
        profileLabel.font = FontManager.shared.font(for: .additionalInformation)
        profileLabel.textColor = Common.Colors.additionalText
        profileLabel.numberOfLines = 0
        profileLabel.lineBreakMode = .byWordWrapping
        profileLabel.text = "Профиль: " + olympiad.profile
        profileLabel.calculateHeight()
        return profileLabel
    }
    
    private func configureClassTextField() {
        view.addSubview(classTextField)
        
        classTextField.pinTop(to: informationStackView.bottomAnchor, 24)
        classTextField.pinLeft(to: view.leadingAnchor, 20)
        
        classTextField.regionDelegate = self
        
        classTextField.tag = 1
    }
    
    private func configureLevelTextField() {
        view.addSubview(diplomaLevelTextField)
        
        diplomaLevelTextField.pinTop(to: classTextField.bottomAnchor, 24)
        diplomaLevelTextField.pinLeft(to: view.leadingAnchor, 20)
        
        diplomaLevelTextField.regionDelegate = self
        
        diplomaLevelTextField.tag = 2
    }
    
    private func configureNextButton() {
        nextButton.titleLabel?.font = FontManager.shared.font(for: .bigButton)
        nextButton.layer.cornerRadius = 13
        nextButton.titleLabel?.tintColor = .black
        nextButton.backgroundColor = UIColor(hex: "#E0E8FE")
        nextButton.setTitle("Добавить", for: .normal)
        
        view.addSubview(nextButton)
        
        nextButton.setHeight(48)
        nextButton.pinLeft(to: view.leadingAnchor, 20)
        nextButton.pinRight(to: view.trailingAnchor, 20)
        nextButton.pinBottom(to: view.bottomAnchor, 43)
        
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    @objc private func didTapNextButton() {
        let request = AddDiploma.Request(
            diplomaClass: diplomaClass,
            diplomaLevel: diplomaLevel
        )
        interactor?.addDiploma(with: request)
    }
}

extension AddDiplomaViewController : OptionsTextFieldDelegate {
    func textWasDeleted(tag: Int) {
        switch tag {
        case 1:
            diplomaClass = nil
        case 2:
            diplomaLevel = nil
        default:
            break
        }
    }
    
    func regionTextFieldDidSelect(option: OptionViewModel) {
        if option.id > 3 {
            diplomaClass = option.id
        } else {
            diplomaLevel = option.id
        }
    }
    
    func regionTextFieldWillSelect(with optionsVC: OptionsViewController) {
        optionsVC.modalPresentationStyle = .overFullScreen
        present(optionsVC, animated: false)
    }
    
    func dissmissKeyboard() {
        view.endEditing(true)
    }
}

extension AddDiplomaViewController : AddDiplomaDisplayLogic {
    func displayAddDiplomaResult(with viewModel: AddDiploma.ViewModel) {
        router?.routeToRoot()
    }
}
