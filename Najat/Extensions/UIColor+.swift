//
//  UIColor+.swift
//  Madares Bus
//
//  Created by youssef on 12/17/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit

public extension UIColor {
    
    static let mainColor = UIColor(named: "MainColor")!
    static let mainBackground = UIColor(named: "MainBackground")!
    static let mainWhite = UIColor(named: "MainWhite")!
    static let mainBlack = UIColor(named: "MainBlack")!
    static let blackAlpha = UIColor(named: "BlackAlpha")!
    static let mainGray = UIColor.hex("#F9F9F9")
    static let borderColor = UIColor(red: 0.957, green: 0.957, blue: 0.973, alpha: 1)
    static let silverColor = UIColor(named: "sliver")!
    static let mango = UIColor(named: "mango")!
    static let lightFont = UIColor.hex("#ADB3DA")
    
    
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static func hex(_ hex: String?) -> UIColor {
        var cString: String = hex?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() ?? ""
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
