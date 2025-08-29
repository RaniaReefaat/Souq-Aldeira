//
//  HTMLLabel.swift
//  App
//
//  Created by Ahmed Taha on 29/01/2024.
//

import UIKit

final class HTMLLabel {
    
    static func changeSize(for htmlString: String, size: Int) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        let modifiedHtmlString = "<span style=\"font-size: \(size)px;\">\(htmlString)</span>"
        
        paragraphStyle.alignment = NSTextAlignment.langTextAlignment
        if let string = try? NSMutableAttributedString(data: modifiedHtmlString.data(using: .utf8)!, options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
            string.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, string.length))
            return string
        }
        return NSMutableAttributedString()
    }
}
