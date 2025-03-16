//
//  AppDelegate.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit
import AuthenticationServices

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var serviceLocator = ServiceLocator.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        customizeDependencies()
        ASCredentialIdentityStore.shared.getState { state in
            print("📊 AutoFill State: \(state)")
            if state.isEnabled {
                print("✅ AutoFill включен!")
            } else {
                print("❌ AutoFill выключен!")
            }
        }
        
        let deviceIdentifier = getDeviceIdentifier()
        if isMiniScreen(identifier: deviceIdentifier) {
            let scaleFactor: CGFloat = 0.85
            FontManager.shared.globalFontScale = scaleFactor
            TabBarViewController.isMiniScreen = true
        }
        
        let backButtonAttributes: [NSAttributedString.Key: Any] = [
            .font: FontManager.shared.font(for: .backButton),
            .foregroundColor: UIColor.systemBlue
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(backButtonAttributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(backButtonAttributes, for: .highlighted)
        
        
        return true
    }
    
    func customizeDependencies() {
        serviceLocator.register(service: AuthManager.shared as AuthManagerProtocol)
        serviceLocator.register(service: NetworkService.shared as NetworkServiceProtocol)
        serviceLocator.register(service: FavoritesManager.shared as FavoritesManagerProtocol)
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return..
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait // Используйте .landscape или другие варианты, если нужно
    }
    
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let mirror = Mirror(reflecting: systemInfo.machine)
        let identifier = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
    
    func isMiniScreen(identifier: String) -> Bool {
        switch identifier {
        case "iPhone13,1", "iPhone14,4", "iPhone14,6", "iPhone10,1", "iPhone10,4":
            return true
        default:
            return false
        }
    }
}

