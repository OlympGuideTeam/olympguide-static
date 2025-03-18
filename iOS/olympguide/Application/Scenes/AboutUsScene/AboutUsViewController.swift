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
//        configureAboutUsLabel()
        configureContactButton()
        configureIOSButton()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "О нас"
    }
    
    private func configureInformationStack() {
        informationStackView.axis = .vertical
        informationStackView.spacing = 10
//        informationStackView.spacing = 20
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
        
        aboutUsLabel.text = "Если вы одинокая красивая девушка в возрасте от 17 до 20 лет, то напишите CEO данной компании Арсению Титаренко в телеграмм"
        
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
    
    @objc func openWebPage(sender: UIButton) {
        guard let contact = sender.currentTitle else { return }
        let realContact = contact.replacingOccurrences(of: "@", with: "")
        guard let url = URL(string: "https://t.me/\(realContact)") else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet
        present(safariVC, animated: true, completion: nil)
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

}
