//
//  NotificationHandler.swift
//  App
//
//  Created by Ahmed Taha on 31/12/2023.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
//import GoogleSignIn

final class NotificationHandler: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    func setup(with application: UIApplication) {
        FirebaseApp.configure()
        setDelegates()
        Task {
            try? await requestNotificationAuthorization(application: application)
        }
    }
    
    func requestNotificationAuthorization(application: UIApplication) async throws {
        let authorizationOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        try await UNUserNotificationCenter.current().requestAuthorization(options: authorizationOptions)
        await application.registerForRemoteNotifications()
    }
    
    private func setDelegates() {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
return false
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    
    @available(iOS 14.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        (UserDefaults.isDriver ?? false) ? handleDriverData(userInfo, didTapped: false) : handleUserData(userInfo, didTapped: false)
        if #available(iOS 14.0, *) {
            return [.list, .badge, .sound, .banner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        let userInfo = response.notification.request.content.userInfo
        (UserDefaults.isDriver ?? false) ? handleDriverData(userInfo, didTapped: true) : handleUserData(userInfo, didTapped: true)
    }
    
    private func handleDriverData(_ userInfo: [AnyHashable: Any], didTapped: Bool) {
    }
    
    func handleUserData(_ userInfo: [AnyHashable: Any], didTapped: Bool) {
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken:- ", fcmToken ?? "Not Registerd")
    }
}

extension UIWindow {
    var topViewController: UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else {
                break
            }
        }
        return top
    }
}
