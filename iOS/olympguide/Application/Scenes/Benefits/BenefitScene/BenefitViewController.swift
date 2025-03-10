//
//  BenefitViewController.swift
//  olympguide
//
//  Created by Tom Tim on 26.02.2025.
//

import UIKit

final class BenefitViewController: UIViewController {
    struct Program {
        let code: String
        let name: String
        let university: String
    }
    
    struct Olympiad {
        let name: String
        let level: Int
        let profile: String
    }
    
    struct Benefit {
        let minClass: Int
        let minDiplomaLevel: Int
        let isBVI: Bool
        
        let confirmationSubjects: [BenefitModel.ConfirmationSubject]?
        let fullScoreSubjects: [String]?
    }
    
    var program: Program?
    var olympiad: Olympiad?
    var benefit: Benefit?
    
    let informationStackView: UIStackView = UIStackView()
    
    init(
        with viewModel: OlympiadWithBenefitViewModel
    ) {
        self.olympiad = Olympiad(
            name: viewModel.olympiadName,
            level: viewModel.olympiadLevel,
            profile: viewModel.olympiadProfile
        )
        
        self.benefit = Benefit(
            minClass: viewModel.minClass,
            minDiplomaLevel: viewModel.minDiplomaLevel,
            isBVI: viewModel.isBVI,
            confirmationSubjects: viewModel.confirmationSubjects,
            fullScoreSubjects: viewModel.fullScoreSubjects
        )
        
        super.init(nibName: nil, bundle: nil)
    }

    init(
        with viewModel: ProgramWithBenefitsViewModel, index: Int
    ) {
        self.program = Program(
            code: viewModel.program.field,
            name: viewModel.program.programName,
            university: viewModel.program.university
        )
        let benefitInformation = viewModel.benefitInformation[index]
        self.benefit = Benefit(
            minClass: benefitInformation.minClass,
            minDiplomaLevel: benefitInformation.minDiplomaLevel,
            isBVI: benefitInformation.isBVI,
            confirmationSubjects: benefitInformation.confirmationSubjects,
            fullScoreSubjects: benefitInformation.fullScoreSubjects
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = .pageSheet
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
        }
        
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let height = informationStackView.frame.height + 20 * 2
        let weight = view.frame.width - 10
        
        self.preferredContentSize = CGSize(width: weight, height: height)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        configureInformatonStack()
        configureOlympiadTitleLabel()
        configureProgramNameLabel()
        configureOlympiadNameLabel()
        configureOlympiadInformation()
        configureBenefitInformationStack()
        configurationConfirmationSubjects()
    }
    
    private func configureInformatonStack() {
        view.addSubview(informationStackView)
        informationStackView.axis = .vertical
        informationStackView.spacing = 17
        informationStackView.distribution = .fill
        informationStackView.alignment = .leading
        
        informationStackView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        informationStackView.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, 20)
        informationStackView.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 20)
    }
    
    private func configureOlympiadTitleLabel() {
        let olympiadTitleLabel: UILabel = UILabel()
        olympiadTitleLabel.font = FontManager.shared.font(for: .tableTitle)
        olympiadTitleLabel.textColor = .black
        olympiadTitleLabel.text = "Льгота"
        olympiadTitleLabel.textAlignment = .center
        
        informationStackView.addArrangedSubview(olympiadTitleLabel)
        
        olympiadTitleLabel.pinCenterX(to: informationStackView.centerXAnchor)
    }
    
    private func configureProgramNameLabel() {
        guard let program = self.program else { return }
        let nameLabel: UILabel = UILabel()
        nameLabel.font = FontManager.shared.font(for: .commonInformation)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        nameLabel.text = program.name
        
        informationStackView.addArrangedSubview(nameLabel)
    }
    
    private func configureOlympiadNameLabel() {
        guard let olympiad = self.olympiad else { return }
        let nameLabel: UILabel = UILabel()
        nameLabel.font = FontManager.shared.font(for: .commonInformation)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        
        nameLabel.text = olympiad.name
        
        informationStackView.addArrangedSubview(nameLabel)
    }
    
    private func configureOlympiadInformation() {
        let olympiadInformationStack = UIStackView()
        
        olympiadInformationStack.axis = .vertical
        olympiadInformationStack.spacing = 7
        olympiadInformationStack.distribution = .fill
        olympiadInformationStack.alignment = .leading
        
        configureCodeLabel(olympiadInformationStack)
        configureUniversityLabel(olympiadInformationStack)
        configureLevelLabel(olympiadInformationStack)
        configureProfileLabel(olympiadInformationStack)
        configureClassLebel(olympiadInformationStack)
        configureMinDiplomaLabel(olympiadInformationStack)
        
        informationStackView.addArrangedSubview(olympiadInformationStack)
    }
    
    private func configureCodeLabel(_ stack: UIStackView) {
        guard let program = self.program else { return }
        let codeLabel: UILabel = UILabel()
        codeLabel.font = FontManager.shared.font(for: .additionalInformation)
        codeLabel.textColor = UIColor(hex: "#787878")
        codeLabel.text = "Код направления: \(program.code)"
        
        stack.addArrangedSubview(codeLabel)
    }
    
    private func configureUniversityLabel(_ stack: UIStackView) {
        guard let program = self.program else { return }
        let universitLabel: UILabel = UILabel()
        universitLabel.font = FontManager.shared.font(for: .additionalInformation)
        universitLabel.textColor = UIColor(hex: "#787878")
        universitLabel.text = "Вуз: \(program.university)"
        
        stack.addArrangedSubview(universitLabel)
    }
    
    private func configureLevelLabel(_ stack: UIStackView) {
        guard let olympiad = self.olympiad else { return }

        let levelLabel: UILabel = UILabel()
        levelLabel.font = FontManager.shared.font(for: .additionalInformation)
        levelLabel.textColor = UIColor(hex: "#787878")
        levelLabel.text = "Уровень: \(String(repeating: "I", count: olympiad.level))"
        
        stack.addArrangedSubview(levelLabel)
    }
    
    private func configureProfileLabel(_ stack: UIStackView) {
        guard let olympiad = self.olympiad else { return }
        let profileLabel: UILabel = UILabel()
        profileLabel.font = FontManager.shared.font(for: .additionalInformation)
        profileLabel.textColor = UIColor(hex: "#787878")
        profileLabel.numberOfLines = 0
        profileLabel.lineBreakMode = .byWordWrapping
        profileLabel.text = "Профиль: \(olympiad.profile)"
        
        stack.addArrangedSubview(profileLabel)
    }
    
    private func configureClassLebel(_ stack: UIStackView) {
        guard let benefit = self.benefit else { return }
        let classLabel: UILabel = UILabel()
        classLabel.font = FontManager.shared.font(for: .additionalInformation)
        classLabel.textColor = UIColor(hex: "#787878")
        classLabel.text = "Класс: \(benefit.minClass)"
        
        stack.addArrangedSubview(classLabel)
    }
    
    private func configureMinDiplomaLabel(_ stack: UIStackView) {
        guard let benefit = self.benefit else { return }
        let minDiplomaLabel = UILabel()
        minDiplomaLabel.font = FontManager.shared.font(for: .additionalInformation)
        minDiplomaLabel.textColor = UIColor(hex: "#787878")
        let minDiplomaLevelText = benefit.minDiplomaLevel == 1 ? "победитель" : "призёр"
        
        minDiplomaLabel.text = "Диплом: \(minDiplomaLevelText)"
        stack.addArrangedSubview(minDiplomaLabel)
    }
    
    private func configureBenefitInformationStack() {
        guard let benefit = self.benefit else { return }
        let benefitInformationStack = UIStackView()
        
        benefitInformationStack.axis = .vertical
        benefitInformationStack.spacing = 7
        benefitInformationStack.distribution = .fill
        benefitInformationStack.alignment = .leading
        
        benefitInformationStack.addArrangedSubview(configureBenefitLabel())
        
        informationStackView.addArrangedSubview(benefitInformationStack)
        
        guard let fullScoreSubjects = benefit.fullScoreSubjects else { return }
        
        for subject in fullScoreSubjects {
            let subjectLabel: UILabel = UILabel()
            subjectLabel.font = FontManager.shared.font(for: .additionalInformation)
            subjectLabel.textColor = UIColor(hex: "#787878")
            subjectLabel.numberOfLines = 0
            subjectLabel.lineBreakMode = .byWordWrapping
            subjectLabel.text = "• \(subject)"
            benefitInformationStack.addArrangedSubview(subjectLabel)
        }
    }
    
    private func configureBenefitLabel() -> UILabel {
        guard let benefit = self.benefit else { return UILabel() }
        let benefitLabel: UILabel = UILabel()
        benefitLabel.font = FontManager.shared.font(for: .additionalInformation)
        benefitLabel.textColor = .black
        benefitLabel.numberOfLines = 0
        benefitLabel.lineBreakMode = .byWordWrapping
        
        let benefitText = benefit.isBVI ? "БВИ" : "100 баллов за ЕГЭ по одному из следующих предметов:"
        
        benefitLabel.text = "Льгота: \(benefitText)"
        
        return benefitLabel
    }
    
    private func configurationConfirmationSubjects() {
        guard
            let confirmationSubjects = benefit?.confirmationSubjects,
                confirmationSubjects.count > 0
        else { return }

        let subjectsStackView: UIStackView = UIStackView()
        subjectsStackView.axis = .vertical
        subjectsStackView.spacing = 7
        subjectsStackView.distribution = .fill
        subjectsStackView.alignment = .leading
        
        subjectsStackView.addArrangedSubview(configureConfirmationLabel(score: confirmationSubjects[0].score))
        
        for subject in confirmationSubjects {
            let subjectLabel: UILabel = UILabel()
            subjectLabel.font = FontManager.shared.font(for: .additionalInformation)
            subjectLabel.textColor = UIColor(hex: "#787878")
            subjectLabel.numberOfLines = 0
            subjectLabel.lineBreakMode = .byWordWrapping
            subjectLabel.text = "• \(subject.subject)"
            subjectsStackView.addArrangedSubview(subjectLabel)
        }
        
        informationStackView.addArrangedSubview(subjectsStackView)
    }
    
    private func configureConfirmationLabel(score: Int) -> UILabel {
        let confirmationLabel: UILabel = UILabel()
        confirmationLabel.font = FontManager.shared.font(for: .commonInformation)
        confirmationLabel.textColor = .black
        confirmationLabel.numberOfLines = 0
        confirmationLabel.lineBreakMode = .byWordWrapping
        
        confirmationLabel.text = "Для подтверждения олимпиады необходимо сдать ЕГЭ на \(score) баллов по одному из следующих предметов:"
        
        return confirmationLabel
    }
}
