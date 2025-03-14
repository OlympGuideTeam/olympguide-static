//
//  TabBarViewController.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - Constants
    private enum Constants {
        // Titles
        static let universitiesTitle = "Вузы"
        static let olympiadsTitle = "Олимпиады"
        static let destinationTitle = "Направления"
        static let profileTitle = "Профиль"
        
        // Icons
        static let universitiesIcon = "graduationcap"
        static let olympiadsIcon = "trophy"
        static var destinationIcon: String {
            if #available(iOS 17.0, *) {
                return "book.pages"
            } else {
                return "menucard"
            }
        }
        static let profileIcon = "person.crop.circle"
        
        // CustomTabBar layout
        static let customTabBarBackgroundColor = UIColor(hex: "#E0E8FE")
        static let customTabBarCornerRadius: CGFloat = 27.5
        static let customTabBarHeight: CGFloat = 55
        static let customTabBarHorizontalPadding: CGFloat = 14
        static let customTabBarVerticalPadding: CGFloat = 22
        static let customTabBarMargins = UIEdgeInsets(top: 0, left: 50, bottom: -10, right: 50)
        
        // Shadow
        static let shadowColor = UIColor.black.cgColor
        static let shadowOpacity: Float = 0.25
        static let shadowOffset = CGSize(width: 5, height: 5)
        static let shadowRadius: CGFloat = 10
    }
    
    static var isMiniScreen: Bool = false
    
    // MARK: - Properties
    let presenter = UniversitiesPresenter()
    let interactor = UniversitiesInteractor()
    let router = UniversitiesRouter()
    
    private let universitiesVC = UniversitiesAssembly.build()
    private let olympiadsVC = OlympiadsAssembly.build()
    private let fieldsVC = FieldsAssembly.build()
    private let profileVC = ProfileAssembly.build()
    
    private lazy var universitiesBtn: TabButton = {
        TabButton(
            title: Constants.universitiesTitle,
            icon: Constants.universitiesIcon,
            tag: 0,
            action: action,
            tintColor: .black
        )
    }()
    
    private lazy var olympiadsBtn: TabButton = {
        TabButton(
            title: Constants.olympiadsTitle,
            icon: Constants.olympiadsIcon,
            tag: 1,
            action: action
        )
    }()
    
    private lazy var destinationBtn: TabButton = {
        TabButton(
            title: Constants.destinationTitle,
            icon: Constants.destinationIcon,
            tag: 2,
            action: action
        )
    }()
    
    private lazy var profileBtn: TabButton = {
        TabButton(
            title: Constants.profileTitle,
            icon: Constants.profileIcon,
            tag: 3,
            action: action
        )
    }()
    
    lazy var customTabBar: UIStackView = {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.backgroundColor = Constants.customTabBarBackgroundColor
        $0.frame = CGRect(
            x: Constants.customTabBarHorizontalPadding,
            y: view.frame.height - Constants.customTabBarHeight - Constants.customTabBarVerticalPadding,
            width: view.frame.width - 2 * Constants.customTabBarHorizontalPadding,
            height: Constants.customTabBarHeight
        )
        $0.layer.cornerRadius = Constants.customTabBarCornerRadius
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = Constants.customTabBarMargins
        return $0
    }(UIStackView())
    
    private lazy var action = UIAction { [weak self] sender in
        guard let button = sender.sender as? UIButton, let self = self else { return }
        
        if self.selectedIndex == button.tag {
            if let navController = self.viewControllers?[button.tag] as? UINavigationController {
                if navController.viewControllers.count > 1 {
                    navController.popToRootViewController(animated: true)
                } else {
                    if let scrollView = navController.view.findScrollView() {
                        let topOffset = CGPoint(x: 0, y: -scrollView.adjustedContentInset.top)
                        scrollView.setContentOffset(topOffset, animated: true)
                    }
                }
            }
        } else {
            self.selectedIndex = button.tag
            self.setIcons(tag: button.tag)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let universitiesNavVC = NavigationBarViewController(rootViewController: universitiesVC)
        let olympiadsNavVC = NavigationBarViewController(rootViewController: olympiadsVC)
        let fieldsNavVC = NavigationBarViewController(rootViewController: fieldsVC)
        let profileNavVC = NavigationBarViewController(rootViewController: profileVC)
        
        setViewControllers([universitiesNavVC, olympiadsNavVC, fieldsNavVC, profileNavVC], animated: true)
        
        if TabBarViewController.isMiniScreen {
            configureCommonTabBar()
        } else {
            configureTabBar()
            setupCustomTabBar()
            setupShadow()
            if #available(iOS 18.0, *) {
                isTabBarHidden = true
            }
            turnOffCommonTabBar()
        }
    }
    
    private func configureCommonTabBar() {
        if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor(hex: "#E0E8FE")
                tabBar.standardAppearance = appearance
                tabBar.scrollEdgeAppearance = appearance
            }
        tabBar.barTintColor = Constants.customTabBarBackgroundColor
        tabBar.tintColor = .black
        additionalSafeAreaInsets.bottom = 0
        if let vcs = viewControllers {
            vcs[0].tabBarItem = UITabBarItem(
                title: Constants.universitiesTitle,
                image: UIImage(systemName: Constants.universitiesIcon),
                tag: 0
            )
            vcs[1].tabBarItem = UITabBarItem(
                title: Constants.olympiadsTitle,
                image: UIImage(systemName: Constants.olympiadsIcon),
                tag: 1
            )
            vcs[2].tabBarItem = UITabBarItem(
                title: Constants.destinationTitle,
                image: UIImage(systemName: Constants.destinationIcon),
                tag: 2
            )
            vcs[3].tabBarItem = UITabBarItem(
                title: Constants.profileTitle,
                image: UIImage(systemName: Constants.profileIcon),
                tag: 3
            )
        }
    }
    
    // MARK: - Configuration
    private func configureTabBar() {
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.barTintColor = .white
    }
    
    private func setupCustomTabBar() {
        view.addSubview(customTabBar)
        customTabBar.addArrangedSubview(universitiesBtn)
        customTabBar.addArrangedSubview(olympiadsBtn)
        customTabBar.addArrangedSubview(destinationBtn)
        customTabBar.addArrangedSubview(profileBtn)
    }
    
    private func setupShadow() {
        customTabBar.layer.shadowColor = Constants.shadowColor
        customTabBar.layer.shadowOpacity = Constants.shadowOpacity
        customTabBar.layer.shadowOffset = Constants.shadowOffset
        customTabBar.layer.shadowRadius = Constants.shadowRadius
        customTabBar.layer.masksToBounds = false
    }
    
    private func turnOffCommonTabBar() {
        if let vcs = viewControllers {
            vcs.forEach { $0.tabBarItem.isEnabled = false }
        }
    }
    
    // MARK: - Helpers
    private func setIcons(tag: Int) {
        [universitiesBtn, olympiadsBtn, destinationBtn, profileBtn].forEach { button in
            button.unfillIcon()
            if button.getTag() == tag {
                button.fillIcon()
            }
        }
    }
}
