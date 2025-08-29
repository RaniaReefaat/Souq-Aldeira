//
//  String+.swift
//  Madares Bus
//
//  Created by youssef on 12/17/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit

struct NSMutableAttributedStringConfig {
    private(set) var text: String
    private(set) var font: UIFont
    private(set) var color: UIColor
    private(set) var alignment: NSTextAlignment
    
    init(text: String?, font: UIFont?, color: UIColor?, alignment: NSTextAlignment?) {
        self.text = text ?? ""
        self.font = font ?? .mediumFont(of: 12)
        self.color = color ?? .mainBlack
        self.alignment = alignment ?? .natural
    }
}

extension NSMutableAttributedString {
    
    convenience init(with config: [NSMutableAttributedStringConfig]) {
        
        guard !config.isEmpty else {
            self.init(string: "")
            return
        }
        
        let firstConfig = config.first!
        
        self.init(string: firstConfig.text,
                  attributes: [
                    .foregroundColor: firstConfig.color,
                    .font: firstConfig.font,
                    .paragraphStyle: NSMutableParagraphStyle(alignment: firstConfig.alignment)
                  ])
        
        let styles = config.dropFirst().map({
            NSAttributedString(string: $0.text, attributes: [
                .foregroundColor: $0.color,
                .font: $0.font,
                .paragraphStyle: NSMutableParagraphStyle(alignment: $0.alignment)
                ])
        })
        
        for style in styles {
            append(style)
        }
    }
    
    
}

extension NSMutableParagraphStyle {
     convenience init(alignment: NSTextAlignment) {
        self.init()
        self.alignment = alignment
    }
}

extension String {
    
    func convertTo12HourFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "h:mm:ss a"
            let outputTime = dateFormatter.string(from: date)
            return outputTime
        } else {
            return nil 
        }
    }
    
    func camelCaseToSnakeCase() -> String {
        guard !isEmpty else { return self }

        var result = [String]()
        let firstCharacterRange = startIndex..<index(after: startIndex)
        result.append(self[firstCharacterRange].lowercased())

        for i in indices.dropFirst() {
            let character = self[i]
            if character.isUppercase {
                result.append("_")
                result.append(character.lowercased())
            } else {
                result.append(String(character))
            }
        }

        return result.joined()
    }
}
