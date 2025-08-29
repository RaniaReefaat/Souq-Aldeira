//
// UIViewController.swift
//
//
//  Created by youssef on 9/16/18.
//  Copyright © 2018 youssef. All rights reserved.
//

import UIKit
import SDWebImage
import Combine
import CoreLocation

extension UIViewController {
    
    func crossDissolvePresent(_ vc: UIViewController) {
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.present(vc, animated: true)
        }
    }
    
    func customPresent(_ vc: UIViewController) {
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc ,animated: true, completion: nil)
    }
    
    func presentCustomTransition(_ vc: UIViewController,transition : SlideInTransitioningDelegate) {
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transition
        present(vc, animated: true, completion: nil)
    }

    func PresentMenu(_ vc: UIViewController) {
//        vc.modalPresentationStyle = .f
        self.present(vc, animated: true)
    }

    func dismiss() {
        dismiss(animated: true)
    }
    
    func push(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushWithoutAnimation(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: false)
    }

    func popTwoScreens() {
        guard let vc = navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 3] else { return }
        navigationController?.popToViewController(vc, animated: false)
    }
    
    func popScreens(_ vc: inout UIViewController) {
        vc = (navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 3])!
        navigationController?.popToViewController(vc, animated: false)
    }
    
    func popToSpecific(vc: UIViewController) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController.nibName == vc.nibName {
              self.navigationController!.popToViewController(aViewController, animated: false)
            } else {
                AppWindowManger.openTabBar()
            }
        }
    }
    
    func push(after: Double, _ vc: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func popMe() {
        navigationController?.popViewController(animated: true)
    }
    
    func popMe(after: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func popToRoot(after: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func navTitle(title: String? = nil) {
        if let title = title, title != "" {
            let titleLabel = UILabel().withTextColor(.white).withText(title)
            titleLabel.font = .mediumFont(of: 20)
            titleLabel.withHeight(25)
            navigationItem.titleView = titleLabel
        }
    }
    
    func navTitleWithImageAndText(titleText: String, imageName: String, image2: String) -> UIView {

        // Creates a new UIView
        let titleView = UIView()

        // Creates a new text label
        let label = UILabel()
        label.text = titleText
        label.sizeToFit()
        label.font = UIFont.semiBoldFont(of: 17)
        label.textColor = .mainBlack
        label.center = titleView.center
        label.textAlignment = .center
        label.textAlignment = NSTextAlignment.center

        // Creates the image view
        let image = UIImageView()
        image.image = UIImage(named: imageName)
        
        // Creates the image view
        let secondImage = UIImageView()
        secondImage.image = UIImage(named: image2)

        // Maintains the image's aspect ratio:
        let imageAspect = image.image!.size.width / image.image!.size.height

        // Sets the image frame so that it's immediately before the text:
        let imageX = label.frame.origin.x - label.frame.size.height * imageAspect
        let imageY = label.frame.origin.y
        
        let image2X = label.frame.origin.x + label.frame.size.width - 1 * imageAspect
        let image2Y = label.frame.origin.y

        let imageWidth = label.frame.size.height * imageAspect
        let imageHeight = label.frame.size.height

        [image, secondImage].forEach {
            $0.contentMode = UIView.ContentMode.scaleAspectFit
        }
        
        image.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        secondImage.frame = CGRect(x: image2X, y: image2Y, width: imageWidth, height: imageHeight)
        
        // Adds both the label and image view to the titleView
        titleView.addSubview(secondImage)
        titleView.addSubview(label)
        titleView.addSubview(image)

        // Sets the titleView frame to fit within the UINavigation Title
        titleView.sizeToFit()

        return titleView
    }

    func configNavBar(title: String? = nil, isLarge: Bool, backgroundColor: UIColor = .white) {
        navigationItem.title = ""
        navigationController?.navigationBar.prefersLargeTitles = isLarge
        navigationController?.navigationBar.isOpaque = true
        navigationController?.navigationBar.backgroundColor = backgroundColor
        navigationController?.navigationBar.tintColor = .mainWhite
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func showAlertController(title: String? = "", message: String?, selfDismissing: Bool = true, time: TimeInterval = 2) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.title = title
        alert.message = message
        
        if !selfDismissing {
            alert.addAction(UIAlertAction(title: "Ok".localize, style: .cancel, handler: nil))
        }
        
        present(alert, animated: true)
        
        if selfDismissing {
            Timer.scheduledTimer(withTimeInterval: time, repeats: false) { time in
                time.invalidate()
                alert.dismiss(animated: true)
            }
        }
    }
    
    func transparentNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func notTransparentNavBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func transperantNavBar(tintColor: UIColor = .black) {
        navigationController?.navigationBar.isOpaque = false
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .mainWhite
        navigationController?.navigationBar.tintColor = tintColor
        setShadowNav()
    }
    
    func setStatusBarColor(to color: UIColor = .mainWhite) {
        var statusBar: UIView
        
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            let frame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame
            statusBar = UIView(frame: frame ?? .zero)
            keyWindow?.addSubview(statusBar)
        } else {
            statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView ?? UIView()
        }
    }
    
    @objc
    func dismissMePlease() {
        dismiss(animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setNavigationItem() {

        let image: UIImage = UIImage.back
        let leftButton = UIButton()
        leftButton.setImage(image, for: .normal)
        leftButton.backgroundColor = .mainWhite
        let mySelectedAttributedTitle = NSAttributedString(string: "", attributes: [.font: UIFont.mediumFont(of: 16)])
        leftButton.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
        leftButton.addTarget { [weak self] in
            guard let self else { return }
            popMe()
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        setShadowNav()
    }
    
    func setNavigationItemWithAction(with action: (() -> Void)?) {

        let image: UIImage = UIImage.back
        let leftButton = UIButton()
        leftButton.setImage(image, for: .normal)
        leftButton.backgroundColor = .mainWhite
        let mySelectedAttributedTitle = NSAttributedString(string: "", attributes: [.font: UIFont.mediumFont(of: 16)])
        leftButton.setAttributedTitle(mySelectedAttributedTitle, for: .normal)
        leftButton.addTarget { [weak self] in
            guard self != nil else { return }
            action!()
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        setShadowNav()
    }
    
    func sendMail(to email: String) {
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.view.alpha = 0.0;
            }
        }, completion: { finished in
            if finished {
                self.view.removeFromSuperview()
            }
        })
    }
    
    func openWhatsapp(with phoneNumber: String){
        let urlWhats = "whatsapp://send?phone=(\(phoneNumber))"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    func makePhoneCall(phoneNumber: String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(phoneCallURL) {
            UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
        } else {
            // Handle the error if the device can't make phone calls
            print("Your device cannot make phone calls.")
        }
    }
    func openLocationInGoogleMapsApp(latitude: String, longitude: String, placeName: String) {
        if let googleMapsURL = URL(string: "comgooglemaps://?q=\(latitude),\(longitude)&center=\(latitude),\(longitude)&zoom=14&views=traffic") {
            if UIApplication.shared.canOpenURL(googleMapsURL) {
                UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
            } else {
                // Google Maps app is not installed, open in a browser
                openLocationInBrowser(latitude: latitude, longitude: longitude, placeName: placeName)
            }
        }
    }
    func openLocationInBrowser(latitude: String, longitude: String, placeName: String) {
        let placeNameEncoded = placeName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let googleMapsWebURL = URL(string: "https://maps.google.com/?q=\(latitude),\(longitude)(\(placeNameEncoded))") {
            UIApplication.shared.open(googleMapsWebURL, options: [:], completionHandler: nil)
        }
    }
    private func setShadowNav() {
        navigationController?.navigationBar.backgroundColor = .mainWhite
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.4
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        navigationController?.navigationBar.layer.shadowRadius = 1
    }
    
    func hideNavigationBar(status: Bool) {
        navigationController?.setNavigationBarHidden(status, animated: true)
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
    }

    @objc 
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController {
//    func addNotificationObserver(name: Notification.Name, selector: Selector) {
//        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
//    }
    
//    func removeNotificationObserver(name: Notification.Name) {
//        NotificationCenter.default.removeObserver(self, name: name, object: nil)
//    }
    
    func removeNotificationsObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    var toNavigation: UINavigationController {
        let nav = AppNavigationController(rootViewController: self)
        return nav
    }
    
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
                    (self.navigationController?.navigationBar.frame.height ?? 0.0)
            return topBarHeight
        }
    }
}

extension UIViewController {
    
    func addChildViewController(childViewController: UIViewController, childViewControllerContainer: UIView, comp: (() -> ())? = nil) {
        
        removeChildViewControllers()
        addChild(childViewController)
        
        childViewControllerContainer.addSubview(childViewController.view)
        childViewController.view.frame = childViewControllerContainer.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParent: self)
        comp?()
    }
    
    func removeChildViewControllers() {
        if children.count > 0 {
            for counter in  1 ..< children.count {
                children[counter].willMove(toParent: nil)
                children[counter].view.removeFromSuperview()
                children[counter].removeFromParent()
            }
        }
    }
}


extension UIViewController {
    
    func openMaps(latitude: Double, longitude: Double) {
        let location = "\(latitude),\(longitude)"
        if let googleMapsURL = URL(string: "comgooglemaps://?daddr=\(location)&directionsmode=driving") {
            if UIApplication.shared.canOpenURL(googleMapsURL) {
                UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
                return
            }
        }
        
        let appleMapsURL = URL(string: "http://maps.apple.com/?daddr=\(location)&dirflg=d&t=h")!
        UIApplication.shared.open(appleMapsURL, options: [:], completionHandler: nil)
    }
}

extension UIImageView {
    func getImageFrom(gradientLayer: CAGradientLayer) -> UIImage? {
        var gradientImage:UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}

extension UINavigationBar {
    
    func getImageFrom(gradientLayer: CAGradientLayer) -> UIImage? {
        var gradientImage: UIImage?
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
            gradientImage = UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
        }
        UIGraphicsEndImageContext()
        return gradientImage
    }
}

extension UIViewController {
    func alertPermission() {
        let alertController = UIAlertController(title: "Location Permission Required".localize, message: "Please enable location permissions in settings.".localize, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Settings".localize, style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        let cancelAction = UIAlertAction(title: "Cancel".localize, style: UIAlertAction.Style.cancel)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func callingMobile(mobile: String?)  {
        guard let phone = mobile else{return}
        let url: NSURL = URL(string: "TEL://\(phone)")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
}

extension UIViewController {
    func tableDesign(TVC: UITableView) {
        TVC.tableFooterView = UIView()
        TVC.separatorInset = .zero
        TVC.contentInset = .zero
    }
}

//MARK: -> Handle timer count for sending verification code
extension UIViewController {
    
    func startTimer(for label: UILabel, resendButton: UIButton) {
        isTimerHidden(false, label: label, button: resendButton)
        var seconds = 60
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self else { return }
            seconds -= 1
            label.text = String(format: "00:%02d", seconds)
            if seconds == 0 {
                timer.invalidate()
                self.isTimerHidden(true, label: label, button: resendButton)
            }
        }
    }
    
    private func isTimerHidden(_ status: Bool, label: UILabel, button: UIButton) {
        label.isHidden = status
        button.isHidden = !status
    }
}
extension UIViewController {
    func openUrl(url: String?) {
        let value = url ?? ""
        guard let _url  = URL(string: value) else{return}
        openURL(url: _url)
    }
    
    @objc func openURL(url:URL){
//        if UIApplication.shared.canOpenURL(url as URL)  {
//            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
//        }else{
//            //            alertNoButton(message: Messages.appNotInstalled)
//        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
