//
//  AppNavigationController.swift
//  Wasselna-New
//
//  Created by Youssef on 14/11/2022.
//

import UIKit

class AppNavigationController: UINavigationController {
    
    let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    private func configure() {
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        }
        
        navigationBar.layer.masksToBounds = false
        navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationBar.layer.shadowOpacity = 0.2
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationBar.layer.shadowRadius = 2
        navigationBar.shadowImage = UIImage()
        
        let backImage = UIImage.back.withRenderingMode(.alwaysOriginal)
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
        
        navigationBar.tintColor = .mainBlack
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = .clear
                
        navigationBar.titleTextAttributes = [
            .font: UIFont.mediumFont(of: 18),
            .foregroundColor: UIColor.blackColor
        ]
        
        let statusBar = UIView(frame: UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
        statusBar.backgroundColor = .whiteColor
        UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.addSubview(statusBar)
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        viewController.navigationItem.backBarButtonItem = backItem
    }
}

extension AppNavigationController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let isRTL = AppMainLang.isRTLLanguage()
        let semantic: UISemanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
        navigationController.view.semanticContentAttribute = semantic
        navigationController.navigationBar.semanticContentAttribute = semantic
    }
}

public extension UINavigationController {
    
    func setTitleColor(to color: UIColor) {
        let font = UIFont.mediumFont(of: 15)
        navigationBar.titleTextAttributes = [
            .font: font,
            .foregroundColor: color
        ]
    }
}
