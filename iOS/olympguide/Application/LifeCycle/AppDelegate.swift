//
//  AppDelegate.swift
//  olympguide
//
//  Created by Tom Tim on 22.12.2024.
//

import UIKit
import UserNotifications
@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var serviceLocator = ServiceLocator.shared
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let center = UNUserNotificationCenter.current()
//        center.delegate = self
//        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if let error = error {
//                print("Ошибка запроса разрешения: \(error)")
//                return
//            }
//            if granted {
//                DispatchQueue.main.async {
//                    application.registerForRemoteNotifications()
//                }
//            } else {
//                print("Пользователь отказал в разрешении на уведомления")
//            }
//        }
        customizeDependencies()
        
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
    
    // Вызывается, когда APNs успешно выдал device token
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { String(format: "%02.2hhx", $0) }
        let token = tokenParts.joined()
        print("Устройство зарегистрировано, token: \(token)")
        // Отправьте этот token на ваш сервер для дальнейшей отправки уведомлений
    }
    
    // Вызывается при ошибке регистрации для удалённых уведомлений
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Ошибка регистрации в APNs: \(error)")
    }
    
    // Обработка уведомлений, когда приложение активно (на переднем плане)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Отобразить уведомление (alert и звук) даже если приложение активно
        completionHandler([.banner, .sound])
    }
    
    // Обработка действий, когда пользователь взаимодействует с уведомлением
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Здесь можно реализовать дополнительную логику по обработке нажатия на уведомление
        print("Пользователь открыл уведомление")
        completionHandler()
    }
    
    func customizeDependencies() {
        serviceLocator.register(service: AuthManager.shared as AuthManagerProtocol)
        serviceLocator.register(service: NetworkService.shared as NetworkServiceProtocol)
        serviceLocator.register(service: FavoritesManager.shared as FavoritesManagerProtocol)
        serviceLocator.register(service: FiltersManager.shared as FiltersManagerProtocol)
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

