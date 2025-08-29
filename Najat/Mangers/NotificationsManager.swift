//
//  NotificationsManager.swift
//  App
//
//  Created by Mohammed Balegh on 18/12/2023.
//

import FirebaseMessaging

struct MessagingHandler {
    static var deviceToken: String {
        return Messaging.messaging().fcmToken ?? "ff"
    }
}
