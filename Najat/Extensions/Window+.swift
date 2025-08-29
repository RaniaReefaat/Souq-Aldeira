//
//  Window+.swift
//  Dinamo
//
//  Created by Youssef on 22/01/2022.
//

import UIKit

extension UIWindow {
    
    var visibleViewController: UIViewController? {
        self.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    func getVisibleViewControllerFrom(_ rootViewController: UIViewController?) -> UIViewController? {
        var rootVC = rootViewController
        if rootVC == nil {
            let keyWindow = UIApplication.shared.windows.first (where: { $0.isKeyWindow })!
            rootVC = keyWindow.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as? UINavigationController
                return navigationController?.viewControllers.last
            }
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as? UITabBarController
                return tabBarController?.selectedViewController
            }
            return getVisibleViewControllerFrom(presented)
        }
        
        return nil
    }
}
