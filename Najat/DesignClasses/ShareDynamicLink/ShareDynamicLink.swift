//
//  ShareDynamicLink.swift
//  MyApp
//
//  Created by Ahmed Taha on 20/02/2024.
//

import UIKit
//import FirebaseDynamicLinks

enum VcType {
    case customShare
    case iosshare
}

class ShareDynamicLink {
    
//    static let shared = ShareDynamicLink()
//    
//    private func createTheURL(vc: UIViewController, component: URLComponents, urlPrefix: String, shareText: String , type : VcType){
//        var shareUrl: URL?
//        guard let linkParameter = component.url,
//              let linkBuilder = DynamicLinkComponents(link: linkParameter, domainURIPrefix: urlPrefix) else { return }
//        
//        if let myBundleId = Bundle.main.bundleIdentifier {
//            linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)
//        }
//        linkBuilder.iOSParameters?.appStoreID = DynaimcLinkConstants.appStoreId
//        linkBuilder.androidParameters = DynamicLinkAndroidParameters(packageName: DynaimcLinkConstants.androidPackageName)
//        linkBuilder.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
//        linkBuilder.socialMetaTagParameters?.title = "MyApp App"
//        linkBuilder.socialMetaTagParameters?.descriptionText = "MyApp App"
//        linkBuilder.socialMetaTagParameters?.imageURL = URL(string: "")
//        linkBuilder.analyticsParameters = DynamicLinkGoogleAnalyticsParameters(source: "IOS APP", medium: "Invite friend", campaign: "\(UserDefaults.userData?.id ?? -1)")
//        linkBuilder.navigationInfoParameters?.isForcedRedirectEnabled = false
//        shareUrl = linkBuilder.url
//        
//        linkBuilder.shorten {url, warnings, error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            if let warnings = warnings {
//                print(warnings)
//            }
//            guard let url = url else { return }
//            shareUrl = url
//            guard let sharedUrl = shareUrl else { return }
//            let shareContent: [Any] = [shareText , sharedUrl.absoluteString]
//            if type == .iosshare {
//                vc.presentActivityControll(shareContent: shareContent)
//            } else {
//                vc.openShareApp(productID: sharedUrl.absoluteString)
//            }
//        }
//    }
//    
//    func shareProfileBtnClicked(vc: UIViewController, profileId: Int, type : VcType) {
//        let shareText = "Hey check out this user"
//        var component = URLComponents()
//        component.scheme = "https"
//        component.host = DynaimcLinkConstants.componentJobHost
//        component.path = "/share"
//        component.queryItems = [.init(name: "product_id", value: "\(profileId)")]
//        createTheURL(vc: vc, component: component, urlPrefix: DynaimcLinkConstants.domainJobURIPrefix, shareText: shareText, type: type)
//    }
//    
//    func shareAppButtonClicked(vc: UIViewController, productID: String, type : VcType) {
//        let shareText = "Shared Product in MyApp"
//        var component = URLComponents()
//        component.scheme = "https"
//        component.host = DynaimcLinkConstants.componentJobHost
//        component.path = "/share"
//        component.queryItems = [.init(name: "product_id", value: "\(productID)")]
//        createTheURL(vc: vc, component: component, urlPrefix: DynaimcLinkConstants.domainJobURIPrefix, shareText: shareText, type: type)
//    }
}

struct DynaimcLinkConstants {
    static let appStoreId = "1587688225"
    static let androidPackageName = "com.MyApp.client"
    static let componentJobHost = "MyAppfinalapp.page.link"
    static let domainJobURIPrefix = "https://MyAppfinalapp.page.link"
}

extension UIViewController {
    
    func presentActivityControll(shareContent: [Any]) {
        let activityController = UIActivityViewController(activityItems: shareContent, applicationActivities: nil)
        if UI_USER_INTERFACE_IDIOM() == .pad {
            if let popup = activityController.popoverPresentationController {
                popup.sourceView = view
                popup.sourceRect = CGRect(x: view.frame.size.width / 2, y: view.frame.size.height / 4, width: 0, height: 0)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    func openShareApp(productID: String) {
//        ShareDynamicLink.shared.shareAppButtonClicked(vc: self, productID: productID, type: .iosshare)
    }
}
