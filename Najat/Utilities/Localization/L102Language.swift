//
//  L102Language.swift
//  Captain One
//
//  Created by Mohamed Akl on 19/06/2022.
//  Copyright © 2022 Mohamed Akl. All rights reserved.
//

import UIKit

// constants
private let APPLE_LANGUAGE_KEY = "AppleLanguages"
enum langugae {
    case arabic
    case english
    
    var lang: String {
        switch self {
        case .arabic:
            return "ar"
        case .english:
            return "en"
        }
    }
}
/// L102Language
class L102Language {
    /// get current Apple language
    class func currentAppleLanguage() -> String {
        let userdef = UserDefaults.standard
        guard let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as? NSArray else { return "" }
        let current = langArray.firstObject as! String
        let endIndex = current.startIndex
        let currentWithoutLocale = current.substring(to: current.index(endIndex, offsetBy: 2))
        return currentWithoutLocale
    }

    class func currentAppleLanguageFull() -> String {
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        return current
    }

    /// set @lang to be the first in Applelanguages list
    class func setAppleLanguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang, currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.synchronize()
    }

    class func getCurrentLanguage() -> String {
        if L102Language.currentAppleLanguage().contains(langugae.arabic.lang) {
            return "ar"
        } else {
            return "en"
        }
    }

    class var isRTL: Bool {
        return L102Language.currentAppleLanguage() == "ar"
    }
}
