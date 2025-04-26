//
//  SceneDelegate.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import Foundation 
import Network
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    @InjectSingleton
    var authManager: AuthManagerProtocol
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
//        _ = NetworkMonitor.shared
        let tabBar = TabBarViewController()
        let uiwindow = UIWindow(windowScene: windowScene)
        window = uiwindow
        uiwindow.rootViewController = tabBar
        
        uiwindow.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        authManager.checkSession()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}



final class TagsContainerView: UIView {
    private var tagViews: [TagView] = []
    var maxWidth: CGFloat = 0
    func configure(requiredSubjects: [String], optionalSubjects: [String], maxWidth: CGFloat = UIScreen.main.bounds.width - 60) {
        // Удаляем старые
        tagViews.forEach { $0.removeFromSuperview() }
        tagViews = []
        self.maxWidth = maxWidth
        // Создаём новые
        for subject in requiredSubjects {
            if let subject = Subject(rawValue: subject) {
                let tagView = TagView(text: subject.abbreviation, isSelected: true)
                addSubview(tagView)
                tagViews.append(tagView)
            }
        }
        
        for subject in optionalSubjects {
            if let subject = Subject(rawValue: subject) {
                let tagView = TagView(text: subject.abbreviation, isSelected: false)
                addSubview(tagView)
                tagViews.append(tagView)
            }
        }
        if let tag = tagViews.last {
            pinBottom(to: tag.bottomAnchor)
        }
        
        if let tag = tagViews.first {
            pinTop(to: tag.topAnchor)
        }
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spacing: CGFloat = 6
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowsCount: CGFloat = 1
        
        for tagView in tagViews {
            let size = tagView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            
            if x + size.width > maxWidth {
                x = 0
                y += 26 + spacing
                
                rowsCount += 1
            }
            
            tagView.frame = CGRect(x: x, y: y, width: size.width, height: 26)
            x += size.width + spacing
        }
        
    }
}


final class TagView: UIView {
    private let label = UILabel()
    
    init(text: String, isSelected: Bool = false) {
        super.init(frame: .zero)
        setup(text: text, isSelected: isSelected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(text: String, isSelected: Bool) {
        let gray = UIColor(hex: "#787878")
        let lightGray = UIColor(hex: "#DFDFDF")
        backgroundColor = isSelected ? lightGray : .white
        layer.borderColor = isSelected ? lightGray?.cgColor : gray?.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        
        label.text = text
        label.font = FontManager.shared.font(weight: .regular, size: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = isSelected ? .black : .gray
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        heightAnchor.constraint(equalToConstant: 26).isActive = true
    }
}
//final class vc: UIViewController {
//    let tagsView = TagsContainerView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        view.addSubview(tagsView)
//
//        tagsView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            tagsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            tagsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            tagsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
//        ])
//
//        tagsView.setTags([
//            ("Мам.", true),
//            ("Рус.", true),
//            ("Инф.", false),
//            ("Физ.", false),
//            ("Инф.", false),
//            ("Анг.", false),
//            ("Физ.", false)
//        ])
//    }
//}


