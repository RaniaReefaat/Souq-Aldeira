//
//  Localization+Extensions.swift
//  App
//
//  Created by Ahmed Taha on 23/11/2023.
//

import UIKit

extension UILabel {
    
    @IBInspectable var localizedTextKey: String {
        get {
            text ?? ""
        } set {
            text = newValue.localized
        }
    }
}

public extension UISegmentedControl {
    
    @IBInspectable var firstSegmentTitleKey: String {
        get {
            ""
        } set {
            self.setTitle(newValue.localized, forSegmentAt: 0)
        }
    }
    
    @IBInspectable var secondSegmentTitleKey: String {
        get {
            ""
        } set {
            self.setTitle(newValue.localized, forSegmentAt: 1)
        }
    }
}

public extension UITextView {
    
    @IBInspectable var localizedTextKey: String {
        get {
            ""
        } set {
            self.text = newValue.localized
        }
    }
}

public extension UIBarButtonItem {
    
    @IBInspectable var localizedTextKey: String {
        get {
            title ?? ""
        } set {
            self.title = newValue.localized
        }
    }
}

public extension UIButton {
    
    @IBInspectable var localizednormalTextKey: String {
        get {
            titleLabel?.text ?? ""
        } set {
            setTitle(newValue.localized, for: .normal)
        }
    }
    
    @IBInspectable var localizedSelectedTextKey: String {
        get {
            titleLabel?.text ?? ""
        } set {
            setTitle(newValue.localized, for: .selected)
        }
    }
    
    @IBInspectable var localizedDisableTextKey: String {
        get {
            titleLabel?.text ?? ""
        } set {
            setTitle(newValue.localized, for: .selected)
        }
    }
}

public extension UINavigationItem {
    
    @IBInspectable var localizedTextKey: String {
        get {
            title ?? ""
        } set {
            self.title = newValue.localized
        }
    }
}

public extension UITextField {
    
    @IBInspectable var keyPlaceholder: String {
        get {
            placeholder ?? ""
        } set {
            self.placeholder = newValue.localized
        }
    }
}

extension String {
    
    var localize: String {
        NSLocalizedString(self, comment: "Hello From String Extension")
    }
    
    var isInt: Bool {
        Int(self) != nil
    }
    
    var int: Int? {
        Int(self)
    }
    
    var double: Double? {
        Double(self)
    }
    
    var toDouble: Double {
        Double(self) ?? 0.0
    }
    
    var addCurrency: String {
        return "\(self) \("KD".localized)"
    }
    
    var toEGPound: String {
        "\(self.int.unwrapped(or: 0) / 100)"
    }
    
    var addKm: String {
        "\(self) \("Km")"
    }
    
    var addTime: String {
        "\(self) \("Min")"
    }
    
    var trimmedString: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func width(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func containsCharactersOutsideSet(characterSet: CharacterSet) -> Bool {
        lowercased().rangeOfCharacter(from: characterSet.inverted) != nil
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    var replacedArabicDigitsWithEnglish: String {
        var string = self
        let map = [
            "٠": "0",
            "١": "1",
            "٢": "2",
            "٣": "3",
            "٤": "4",
            "٥": "5",
            "٦": "6",
            "٧": "7",
            "٨": "8",
            "٩": "9"
        ]
        map.forEach { string = string.replacingOccurrences(of: $0, with: $1) }
        return string
    }
    
    var withCommasRemoved: String {
        replacingOccurrences(of: ",", with: "")
    }
    
    func slice(from: String, to: String) -> String? {
        (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

public extension String {
    
    func getLocalized(arg: CVarArg...) -> String {
        .init(format: self.localized, arguments: arg)
    }
    
    var isArabic: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "(?s).*\\p{Arabic}.*")
        return predicate.evaluate(with: self)
    }
    
    func validString() -> String {
        self.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil)
    }
}
