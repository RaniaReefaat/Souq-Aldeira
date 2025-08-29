//
//  Font.swift
//  SaudiMarch
//
//  Created by Youssef on 9/29/22.
//  Copyright © 2022 Youssef. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func lightFont(of size: CGFloat) -> UIFont {
        return UIFont(name: "FontsFree-Net-Kalligraaf-Arabic-Light", size: size) ?? UIFont.systemFont(ofSize: 14)
    }
    
    static func boldFont(of size: CGFloat) -> UIFont {
        return UIFont(name: "KalligArb-Bold", size: size) ?? UIFont.systemFont(ofSize: 14)
    }
    
    static func semiBoldFont(of size: CGFloat) -> UIFont {
        return UIFont(name: "KalligArb-Semibold", size: size) ?? UIFont.systemFont(ofSize: 14)
    }
    
    
    static func regularFont(of size: CGFloat) -> UIFont {
        return UIFont(name: "KalligArb-Regular", size: size) ?? UIFont.systemFont(ofSize: 14)
    }
    
    static func cairoBlack(of size: CGFloat) -> UIFont {
        return UIFont(name: "NeoSansProBold", size: size) ?? UIFont.systemFont(ofSize: 14)
    }
    static func mediumFont(of size: CGFloat) -> UIFont {
        return UIFont(name: "KalligArb-Medium", size: size) ?? UIFont.systemFont(ofSize: 100)
    }
    
    
    var bold: UIFont {
        return UIFont(descriptor: fontDescriptor.withSymbolicTraits(.traitBold)!, size: 0)
    }
}
