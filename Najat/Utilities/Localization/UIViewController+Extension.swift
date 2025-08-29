//
//  UIViewController+Extension.swift
//  Captain One
//
//  Created by Mohamed Akl on 19/06/2022.
//  Copyright © 2022 Mohamed Akl. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

extension UIViewController: UIGestureRecognizerDelegate {
    
    func addPopGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func setActivityIndicator(play: Bool, activityIndicator: UIActivityIndicatorView) {
        if play {
            activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
        } else {
            activityIndicator.stopAnimating()
            view.isUserInteractionEnabled = true
        }
    }
    
    func forceToArabic(vc: UIViewController) {
        L102Language.setAppleLanguageTo(lang: langugae.arabic.lang)
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        UserDefaults.standard.set("yes", forKey: "lang")
        changeWindow(vc: vc)
    }
    
    func changeWindow(vc: UIViewController) {
        let rootViewController: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        rootViewController.rootViewController = vc
        let mainWindow = (UIApplication.shared.delegate?.window!)!
        mainWindow.backgroundColor = .black
        UIView.transition(with: mainWindow, duration: 0.55001, options: .transitionCrossDissolve, animations: { () -> Void in
        }) { (_) -> Void in
        }
    }
    
    func animateIn(_ myView: UIView) {
        myView.center = self.view.center
        myView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        myView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            myView.alpha = 1
            myView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut (_ myView: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            myView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            myView.alpha = 0
        }) { (success:Bool) in
            self.dismissMe()
        }
    }
    
    func forceToEnglish(vc: UIViewController) {
        L102Language.setAppleLanguageTo(lang: langugae.english.lang)
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        UserDefaults.standard.set("yes", forKey: "lang")
        changeWindow(vc: vc)
    }
    
    func changeLanguage(vc: UIViewController) {
        if L102Language.currentAppleLanguage() == langugae.english.lang {
            L102Language.setAppleLanguageTo(lang: langugae.arabic.lang)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            L102Language.setAppleLanguageTo(lang: langugae.english.lang)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        changeWindow(vc: vc)
    }
  @objc func dismissMe(){
      DispatchQueue.main.async(execute: {
         self.dismiss(animated: true, completion: nil)
     })
    }
}

extension UITableView {
    @IBInspectable
    var hideSeparatorForEmptyCells: Bool {
        set {
            tableFooterView = newValue ? UIView() : nil
        }
        get {
            return tableFooterView == nil
        }
    }
}



extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
extension UIViewController{

}
extension UIViewController{
    func getThumbnailFromVideo(url: URL, completion: @escaping (UIImage?) -> Void) {
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        // Generate thumbnail at the 1-second mark
        let time = CMTime(seconds: 1, preferredTimescale: 60)
        assetImageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, cgImage, _, result, error in
            if let cgImage = cgImage, result == .succeeded {
                let thumbnail = UIImage(cgImage: cgImage)
                completion(thumbnail)
            } else {
                print("Failed to generate thumbnail: \(String(describing: error))")
                completion(nil)
            }
        }
    }
}
