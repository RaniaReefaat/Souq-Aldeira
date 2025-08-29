//
//  Navigation.swift
//  Captain One
//
//  Created by Mohamed Akl on 19/06/2022.
//  Copyright © 2022 Mohamed Akl. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    
    // MARK: - Transparent With Nav Bar
//    func transparentNavBar() {
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
//
//    }
    func addNotifyButton(){
        let notifyImage = UIImage(named: "notify")
        let notifyButton = UIButton()
        notifyButton.setImage(notifyImage, for: .normal)
        notifyButton.addTarget(self, action: #selector(notifyButtonTapped), for: .touchUpInside)
        notifyButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        let customBarButton = UIBarButtonItem(customView: notifyButton)
        
        navigationItem.rightBarButtonItem = customBarButton
        
    }
    @objc func notifyButtonTapped() {
        push(NotificationViewController())
        print("notification tapped")
    }
    func setTitle(_ title: String){
        navigationItem.title = title
    }
    
    func setTitleImage(name:String){
        let logo = UIImage(named: name)
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    
    func setNavImage(name:String){
        let logo = UIImage(named: name)
        
        let imageView = UIImageView(image:logo)
        //        imageView.contentMode = .scaleToFill
        self.navigationController?.navigationBar.setBackgroundImage(imageView.image?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    // MARK: - Transparent With Nav Bar
//    func notTransparentNavBar() {
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = false
//    }

    func giveNavigationStyle(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.4662680626, blue: 0.2695541978, alpha: 1)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    func removeNavigationStyle(){
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
    }
    func HideNavigationBar(status: Bool){
        navigationController?.setNavigationBarHidden(status, animated: true)
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem

    }
    func HideTabBar(status: Bool){
        tabBarController?.tabBar.isHidden = status
        tabBarController?.tabBar.isTranslucent = status

    }
    func setStatusBarColor(color: UIColor){
//        UIApplication.shared.statusBarUIView?.backgroundColor = color
    }
    func setBackButtonTitle(txt: String?){
        let backBarBtnItem = UIBarButtonItem()
        backBarBtnItem.title = txt
        navigationItem.backBarButtonItem = backBarBtnItem

    }
    func textPadding(tf: UITextField){
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 14.0, height: 2.0))
        tf.leftView = leftView
        tf.rightView = leftView
        tf.leftViewMode = .always
        tf.rightViewMode = .always
    }
    func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func popView(){
        self.navigationController?.popViewController(animated: true)
    }
    func popToRootView(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}
