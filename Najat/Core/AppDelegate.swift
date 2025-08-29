//
//  AppDelegate.swift
//  Najat
//
//  Created by rania refaat on 20/05/2024.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import AlamofireEasyLogger

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    let alamofireLogger = FancyAppAlamofireLogger(prettyPrint: true) {
        print($0)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        setLanguage()
        setRoot()
        iniGoogleMap()
        L102Localizer.DoTheMagic()
        
        UIScrollView().contentInsetAdjustmentBehavior = .never
        
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        return true
        
    }
    
}
extension AppDelegate {
    private func iniGoogleMap() {
        GMSServices.provideAPIKey(Constants.apiGoogleMap)
    }
    func configWindow() {
        AppDelegate.shared.window?.rootViewController =  SplashViewController()

        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    func setRoot(){
        window = UIWindow()
        AppDelegate.shared.window?.rootViewController =  SplashViewController()
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
    private func setLanguage() {
        let lang = UserDefaults.UserSelectLang
            if lang == nil {
                if let preferredLanguage = Locale.preferredLanguages.first {
                    // Set the language
                    UserDefaults.standard.set([preferredLanguage], forKey: "AppleLanguages")
                    UserDefaults.standard.synchronize()
                    let mySubstring = "\(preferredLanguage.prefix(2))"
                    if mySubstring == "ar"{
                        UIView.appearance().semanticContentAttribute = .forceRightToLeft
                    }else{
                        UIView.appearance().semanticContentAttribute = .forceLeftToRight
                    }
                }
            }
    }
    
    func restartApplication() {
        guard let window = self.window else { return }
        
        let initialViewController = SplashViewController()
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
             window.rootViewController = initialViewController
            window.makeKeyAndVisible()
         })
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "souq-aldira" {
            let host = url.host
              let pathComponents = url.pathComponents
            let path = url.path
            print(pathComponents[0])
              // Check if the URL has the expected format
              if host == "host" {
                  guard let tab = window?.rootViewController as? UITabBarController else{return false}
                  guard  let nav = tab.selectedViewController as? UINavigationController else{return false}
                  guard let vc = nav.viewControllers.last else {return false}
                  let stringURl = url.absoluteString
                  let adID = pathComponents.last ?? "0"
                  let id = Int(adID) ?? 0
                  if stringURl.contains("product"){
                      vc.push(ProductDetailsViewController(productID: id, delegate: nil))
                  }else if stringURl.contains("store"){
                      let userData = UserDefaults.userData
                      let userType = userData?.role ?? .user
                      if userType == .store {
                          let userID = userData?.id ?? 0
                          if userID == id {
                              tab.selectedIndex = 4
                          }
                      }else{
                          vc.push(StoreDetailsViewController(storeID: id))
                      }
                  }
                  return true
              }
        }
        return false
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let url = userActivity.webpageURL {
            // Handle the URL and navigate
            print("Opened via Universal Link: \(url)")
        }
        return true
    }
}
extension UICollectionViewFlowLayout {
    override open var flipsHorizontallyInOppositeLayoutDirection: Bool {
        return  UIApplication.shared.userInterfaceLayoutDirection == UIUserInterfaceLayoutDirection.rightToLeft
    }
}
