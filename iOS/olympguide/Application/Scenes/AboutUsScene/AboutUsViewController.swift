//
//  AboutUsViewController.swift
//  olympguide
//
//  Created by Tom Tim on 27.02.2025.
//

import UIKit
import SafariServices

final class AboutUsViewController : UIViewController {
    let informationStackView: UIStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        configureNavigationBar()
        
        configureInformationStack()
        configureAboutUsLabel()
        configureCareerButton()
        configureContactButton()
        configureIOSButton()
        configureSundaytiButton()
        configureEasyeeeyeButton()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "О нас"
    }
    
    private func configureInformationStack() {
        informationStackView.axis = .vertical
        informationStackView.spacing = 10
        informationStackView.spacing = 20
        informationStackView.distribution = .fill
        informationStackView.alignment = .leading
        
        view.addSubview(informationStackView)
        
        informationStackView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        informationStackView.pinLeft(to: view.safeAreaLayoutGuide.leadingAnchor, 20)
        informationStackView.pinRight(to: view.safeAreaLayoutGuide.trailingAnchor, 20)
    }
    
    private func configureAboutUsLabel() {
        let aboutUsLabel: UILabel = UILabel()
        aboutUsLabel.font = FontManager.shared.font(for: .commonInformation)
        aboutUsLabel.textColor = .black
        aboutUsLabel.numberOfLines = 0
        aboutUsLabel.lineBreakMode = .byWordWrapping
        
        aboutUsLabel.text = "Мы строим самый масштабный edu-tech продукт в России и СНГ. Создаём и развиваем собственные решения и технологии, внимательно следим и корректируем траекторию развития проекта, привлекаем молодых специалистов.\nПрисоединяйся!\n"
        
        informationStackView.addArrangedSubview(aboutUsLabel)
    }
    
    private func configureContactButton() {
        let contactButton = UIButton()
        let title = NSAttributedString(
            string: "GitHub Backend",
            attributes: [
                .foregroundColor: UIColor.black,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .font: FontManager.shared.font(for: .bigButton)
            ]
        )
        contactButton.setAttributedTitle(title, for: .normal)
        
        contactButton.addTarget(self, action: #selector(openBack), for: .touchUpInside)
        
        informationStackView.addArrangedSubview(contactButton)
    }
    
    private func configureCareerButton() {
        let contactButton = UIButton()
        let title = NSAttributedString(
            string: "OlympGuide Career",
            attributes: [
                .foregroundColor: UIColor.black,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .font: FontManager.shared.font(for: .bigButton)
            ]
        )
        contactButton.setAttributedTitle(title, for: .normal)
        
        contactButton.addTarget(self, action: #selector(openCareer), for: .touchUpInside)
        
        informationStackView.addArrangedSubview(contactButton)
    }
    
    private func configureIOSButton() {
        let contactButton = UIButton()
        let title = NSAttributedString(
            string: "GitHub iOS",
            attributes: [
                .foregroundColor: UIColor.black,
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .font: FontManager.shared.font(for: .bigButton)
            ]
        )
        contactButton.setAttributedTitle(title, for: .normal)
        
        contactButton.addTarget(self, action: #selector(openIOS), for: .touchUpInside)
        
        informationStackView.addArrangedSubview(contactButton)
    }
    
    private func configureSundaytiButton() {
        let containerView = UIView() // Контейнер для текста и кнопки
        let label = UILabel()
        _ = UIButton(type: .custom)
        
        // Настройка текста
        let fullText = "iOS Developer: @sundayti"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Стиль для всего текста
        attributedString.addAttributes([
            .font: FontManager.shared.font(for: .bigButton),
            .foregroundColor: UIColor.black
        ], range: NSRange(location: 0, length: fullText.count))
        
        // Стиль для "@sundayti" (подчёркивание)
        let linkRange = (fullText as NSString).range(of: "@sundayti")
        attributedString.addAttributes([
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ], range: linkRange)
        
        label.attributedText = attributedString
        label.isUserInteractionEnabled = true
        
        // Добавляем распознавание касания
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnSundaytiLabel(_:)))
        label.addGestureRecognizer(tapGesture)
        
        // Настройка контейнера
        containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        informationStackView.addArrangedSubview(containerView)
    }
    
    @objc private func handleTapOnSundaytiLabel(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let attributedText = label.attributedText else { return }
        
        let tapLocation = gesture.location(in: label)
        
        // Определяем, был ли тап по "@sundayti"
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.size = label.bounds.size
        
        let characterIndex = layoutManager.characterIndex(
            for: tapLocation,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        let linkRange = (attributedText.string as NSString).range(of: "@sundayti")
        
        if NSLocationInRange(characterIndex, linkRange) {
            openTelegram(contact: "@sundayti")
        }
    }
    
    private func configureEasyeeeyeButton() {
        let containerView = UIView() // Контейнер для текста и кнопки
        let label = UILabel()
        
        // Настройка текста
        let fullText = "Backend Developer: @easyeeeye"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Стиль для всего текста
        attributedString.addAttributes([
            .font: FontManager.shared.font(for: .bigButton),
            .foregroundColor: UIColor.black
        ], range: NSRange(location: 0, length: fullText.count))
        
        // Стиль для "@sundayti" (подчёркивание)
        let linkRange = (fullText as NSString).range(of: "@easyeeeye")
        attributedString.addAttributes([
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ], range: linkRange)
        
        label.attributedText = attributedString
        label.isUserInteractionEnabled = true
        
        // Добавляем распознавание касания
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnEasyeeeyeLabel(_:)))
        label.addGestureRecognizer(tapGesture)
        
        // Настройка контейнера
        containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: containerView.topAnchor),
            label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        informationStackView.addArrangedSubview(containerView)
    }
    
    @objc private func handleTapOnEasyeeeyeLabel(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let attributedText = label.attributedText else { return }
        
        let tapLocation = gesture.location(in: label)
        
        // Определяем, был ли тап по "@sundayti"
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.size = label.bounds.size
        
        let characterIndex = layoutManager.characterIndex(
            for: tapLocation,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        
        let linkRange = (attributedText.string as NSString).range(of: "@easyeeeye")
        
        if NSLocationInRange(characterIndex, linkRange) {
            openTelegram(contact: "@easyeeeye")
        }
    }
    
    private func openTelegram(contact: String) {
        let realContact = contact.replacingOccurrences(of: "@", with: "")
        guard let telegramAppURL = URL(string: "tg://resolve?domain=\(realContact)") else { return }
        guard let webUrl = URL(string: "https://t.me/\(realContact)") else { return }
        
        if UIApplication.shared.canOpenURL(telegramAppURL) {
            UIApplication.shared.open(telegramAppURL, options: [:], completionHandler: nil)
        } else {
            let safariVC = SFSafariViewController(url: webUrl)
            safariVC.modalPresentationStyle = .pageSheet
            present(safariVC, animated: true, completion: nil)
        }
    }
    
    @objc func openBack(sender: UIButton) {
        guard let url = URL(string: "https://github.com/OlympGuideTeam/olympguide-backend") else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true, completion: nil)
    }
    
    @objc func openIOS(sender: UIButton) {
        guard let url = URL(string: "https://github.com/OlympGuideTeam/olympguide-static") else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true, completion: nil)
    }
    
    @objc func openCareer(sender: UIButton) {
        guard let url = URL(string: "https://olympguide.ru/career") else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true, completion: nil)
    }
}
