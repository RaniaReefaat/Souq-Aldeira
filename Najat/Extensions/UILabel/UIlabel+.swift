//
//  Lable+.swift
//  AMNUH-Driver
//
//  Created by Youssef on 1/19/20.
//  Copyright © 2020 Youssef. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont, textColor: UIColor) {
        self.init(frame:.zero)
        self.font = font
        self.text = text
        self.textColor = textColor
    }
    
    var textCenter: UILabel {
        textAlignment = .center
        return self
    }
    
    var lineZero: UILabel {
        numberOfLines = 0
        return self
    }
    
    var centerZero: UILabel {
        textAlignment = .center
        numberOfLines = 0
        return self
    }
}

extension UILabel {
    
    func underLine() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: self.text ?? "", attributes: underlineAttribute)
        self.attributedText = underlineAttributedString
    }
    
    func setTextWithStrike(text: String, value: Int) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: value, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
