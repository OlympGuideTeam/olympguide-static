//
//  ProfileViewController.swift
//  olympguide
//
//  Created by Tom Tim on 10.01.2025.
//

import UIKit
import Combine

// MARK: - Constants
fileprivate enum Constants {
    enum Colors {
        static let refreshTint = UIColor.systemCyan
        static let searchButtonTint = UIColor.black
        static let tableViewBackground = UIColor.white
        static let titleLabelTextColor = UIColor.black
    }
    
    enum Fonts {
        static let titleLabelFont = FontManager.shared.font(for: .largeTitleLabel)
    }
    
    enum Dimensions {
        static let titleLabelTopMargin: CGFloat = 25
        static let titleLabelLeftMargin: CGFloat = 20
        static let searchButtonSize: CGFloat = 33
        static let searchButtonRightMargin: CGFloat = 20
        static let tableViewTopMargin: CGFloat = 13
    }
    
    enum Strings {
        static let profileTitle = "Профиль"
        static let backButtonTitle = "Профиль"
    }
    
    enum Images {
        static let searchIcon: String =  "magnifyingglass"
    }
}

class ProfileViewController: UIViewController {
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    var router: ProfileRoutingLogic?
    let authLabels: [String] = [
//        "Личные данные",
        "Мои дипломы",
        "Избранные ВУЗы",
        "Избранные программы",
        "Избранные олимпиады",
//        "Тема приложения",
        "О нас"
    ]
    
    let nonAuthLabels: [String] = [
        "О нас"
    ]
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        
        let backItem = UIBarButtonItem(
            title: Constants.Strings.backButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )
        
        navigationItem.backBarButtonItem = backItem
        
        authManager.isAuthenticatedPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self]  _ in
                self?.tableView.reloadData()
            }.store(in: &cancellables)
        
    }
    
    private func configureNavigationBar() {
        navigationItem.title = Constants.Strings.profileTitle
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.frame = view.bounds
        
        tableView.backgroundColor = .white
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        
        let versionLabel = UILabel(frame: footerView.bounds)
        versionLabel.textAlignment = .center
        versionLabel.font = FontManager.shared.font(for: .additionalInformation)
        versionLabel.textColor = .gray
        
        if
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        {
            versionLabel.text = "Версия приложения \(version) (\(build))"
        }
        
        footerView.addSubview(versionLabel)
        tableView.tableFooterView = footerView
    }
    
    // MARK: - Actions
    @objc private func registerButtonTapped() {
        router?.routeToSignUp()
    }
    
    @objc private func loginButtonTapped() {
        router?.routeToSignIn()
    }
    
    @objc private func logoutButtonTapped() {
        authManager.logout(completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension ProfileViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if authManager.isAuthenticated {
            return authLabels.count + 1
        } else {
            return nonAuthLabels.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !authManager.isAuthenticated {
            if indexPath.row == 0 {
                let cell = ProfileButtonTableViewCell()
                cell.configure(
                    title: "Зарегистрироваться",
                    borderColor: UIColor(hex: "#FF2D55"),
                    textColor: .black
                )
                cell.actionButton.addTarget(
                    self,
                    action: #selector(registerButtonTapped),
                    for: .touchUpInside
                )
                return cell
            } else if indexPath.row == 1 {
                let cell = ProfileButtonTableViewCell()
                cell.configure(
                    title: "Войти",
                    borderColor: UIColor(hex: "#32ADE6"),
                    textColor: .black
                )
                cell.actionButton.addTarget(
                    self,
                    action: #selector(loginButtonTapped),
                    for: .touchUpInside
                )
                return cell
            } else {
                let cell = ProfileTableViewCell()
                cell.configure(title: nonAuthLabels[indexPath.row - 2])
                cell.hideSeparator(indexPath.row == nonAuthLabels.count + 2 - 1)
                return cell
            }
        } else {
            if indexPath.row <= authLabels.count - 1 {
                let cell = ProfileTableViewCell()
                cell.configure(title: authLabels[indexPath.row])

                cell.hideSeparator(indexPath.row == authLabels.count - 1)
                return cell
            }
            else {
                let cell = ProfileButtonTableViewCell()
                cell.configure(
                    title: "Выйти",
                    borderColor: UIColor(hex: "#FF2D55"),
                    textColor: .black
                )
                cell.actionButton.addTarget(
                    self,
                    action: #selector(logoutButtonTapped),
                    for: .touchUpInside
                )
                return cell
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ProfileViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard
            let cell = tableView.cellForRow(at: indexPath) as? ProfileTableViewCell
        else { return }
        
        switch cell.label.text {
        case "О нас":
            router?.routToAboutUs()
        case "Избранные олимпиады":
            router?.routToFavoriteOlympiads()
        case "Избранные ВУЗы":
            router?.routToFavoriteUniversities()
        case "Избранные программы":
            router?.routToFavoritePrograms()
        case "Мои дипломы":
            router?.routeToDiplomas()
        default:
            break
        }

    }
}
