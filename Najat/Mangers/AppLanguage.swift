//
//  AppMainLang.swift
//  Driver App
//
//  Created by youssef on 4/12/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import UIKit

struct AppMainLang {
    
    private init() { }
    
    static var appMainLang: String {
        get {
            let userdef = UserDefaults.standard
            let langArray = userdef.object(forKey: "AppleLanguages") as! NSArray
            let current = langArray.firstObject as! String
            let endIndex = current.index(current.startIndex, offsetBy: 2)
            let currentWithoutLocale = current[current.startIndex..<endIndex]
            return String(currentWithoutLocale)
        }
    }
    
    static func isRTLLanguage(language: String = appMainLang) -> Bool {
        return language.hasPrefix("ar") || language.hasPrefix("fa")
    }
    
    static var langTextAlignment: NSTextAlignment {
        get {
            if AppMainLang.isRTLLanguage() {
                return .right
            } else {
                return .left
            }
        }
    }
}

extension NSTextAlignment {
    static var langTextAlignment: NSTextAlignment {
        get {
            return AppMainLang.langTextAlignment
        }
    }
}
