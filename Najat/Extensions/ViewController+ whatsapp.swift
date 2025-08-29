//
//  ViewController+ whatsapp.swift
//  Rasan
//
//  Created by rania refaat on 15/05/2024.
//

import UIKit

extension UIViewController{
    func openWhatsApp(withPhoneNumber phoneNumber: String, messageText: String?) {
        let appURL = createWhatsAppURL(phoneNumber: phoneNumber, messageText: messageText)
        let webURL = createWebWhatsAppURL(phoneNumber: phoneNumber, messageText: messageText)
        
        if UIApplication.shared.canOpenURL(appURL) {
            openURL(url: appURL)
        } else {
            openURL(url: webURL)
        }
        print(appURL)
        print(webURL)

    }
    func createWhatsAppURL(phoneNumber: String, messageText: String?) -> URL {
        var textUrl = "whatsapp://send?phone=\(phoneNumber)"
        if messageText != nil {
            textUrl += "&text=\(messageText!)"
        }
        return URL(string: textUrl)!
    }

    func createWebWhatsAppURL(phoneNumber: String, messageText: String?) -> URL {
        var textUrl =  "https://wa.me/\(phoneNumber)"
        if messageText != nil {
            textUrl += "&text=\(messageText!)"
        }
        return URL(string: textUrl)!
    }
}
