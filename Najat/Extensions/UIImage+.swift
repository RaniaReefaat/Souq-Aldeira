//
//  UIImage+.swift
//  Driver App
//
//  Created by youssef on 4/12/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import UIKit

extension UIImage {
    var template: UIImage {
        self.withRenderingMode(.alwaysTemplate)
    }
    
    var original: UIImage {
        self.withRenderingMode(.alwaysOriginal)
    }
}

extension UIImage {
    func toData() -> Data? {
        jpegData(compressionQuality: 0.5)
    }
}

// swift lint:disable force_unwrapping

extension UIImage {
    static let home1 = UIImage(named: "home1")!
    static let home2 = UIImage(named: "home2")!
    static let love1 = UIImage(named: "love1")!
    static let love2 = UIImage(named: "love2")!
    static let cart1 = UIImage(named: "cart1")!
    static let cart2 = UIImage(named: "cart2")!

    static let tabAdd = UIImage(named: "tabAdd")!

    static let check = UIImage(named: "check")!
    static let unCheck = UIImage(named: "unCheck")!

    
    static let blackLocation = UIImage(named: "blackLocation")!
    static let grayLocation = UIImage(named: "grayLocation")!
    static let current = UIImage(named: "currentLocation")!
    
    static let closeEye = UIImage(named: "visibility_off")!
    static let openEye = UIImage(named: "visibility_on")!
    static let back = UIImage(named: "back")!

    static let logo = UIImage(named: "logo")!
    static let vectorLogo = UIImage(named: "WLogo")!
    
    static let emptyAddressIcon = UIImage(named: "emptyAddress")!
}
