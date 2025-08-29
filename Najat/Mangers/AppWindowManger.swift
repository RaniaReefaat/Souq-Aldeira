//
//  AppWindowManger.swift
//  SaudiMarch
//
//  Created by Youssef on 06/11/2022.
//  Copyright © 2022 Youssef. All rights reserved.
//

import UIKit

class AppWindowManger {
    
    private init() { }
    
    static func goToTabBarAndRemoveUserDefaults() {
        UserDefaults.userData = nil
        UserDefaults.isLoggedIn = false
        UserDefaults.isDriver = false
        UserDefaults.token = GuestToken.randomToken(length: 40)
    }
    
    static func makeTransition(to vc: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            weak var keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }!
            keyWindow?.rootViewController = vc
            UIView.transition(with: keyWindow!, duration: 0.5, options: .curveEaseIn, animations: nil, completion: nil)
        }
    }
    
    static func openTabBar() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            keyWindow?.rootViewController = TabBarViewController()
            UIView.transition(with: keyWindow!, duration: 0.5, options: .curveEaseIn, animations: nil, completion: nil)
        }
    }
    
    static func openLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            keyWindow?.rootViewController = LoginViewController().toNavigation
            UIView.transition(with: keyWindow!, duration: 0.5, options: .curveEaseIn, animations: nil, completion: nil)
        }
    }
}
