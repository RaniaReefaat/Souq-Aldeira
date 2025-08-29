//
//  SplashViewController.swift
//  App
//
//  Created by Ahmed Taha on 12/11/2023.
//

import UIKit

final class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            print(UserDefaults.userData?.token)
            if (UserDefaults.userData?.token) != nil {
                AppWindowManger.openTabBar()
            }else{
                AppWindowManger.openLogin()
            }
        }
    }
}
