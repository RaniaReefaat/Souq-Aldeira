//
//  StringWithLine.swift
//  App
//
//  Created by Ahmed Taha on 06/12/2023.
//

import UIKit

extension String {
    var setLineOnText: NSMutableAttributedString {
        let attributedString: NSMutableAttributedString = .init(string: self)
        attributedString.addAttribute(
            .strikethroughStyle,
            value: 2,
            range: .init(location: 0, length: attributedString.length)
        )
        attributedString.addAttribute(
            .strikethroughColor,
            value: UIColor.red,
            range: .init(location: 0, length: attributedString.length)
        )
        return attributedString
    }
}
