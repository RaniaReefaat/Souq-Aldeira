//
//  SwiftUi.swift
//  Driver App
//
//  Created by youssef on 4/12/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import UIKit

protocol AppSwiftUI {
    @discardableResult
    func withShadow() -> Self
    
    @discardableResult
    func withBorder(width: CGFloat, color: UIColor) -> Self
    
    @discardableResult
    func withTint(_ color: UIColor) -> Self
    
    @discardableResult
    func withClip() -> Self
    
    @discardableResult
    func withCorner(_ value: CGFloat) -> Self
    
    @discardableResult
    func withBackColor(_ color: UIColor) -> Self
}

extension AppSwiftUI where Self: UIView {
    
    @discardableResult
    func withShadow() -> Self {
        applySketchShadow()
        return self
    }
    
    @discardableResult
    func withBorder(width: CGFloat = 1.2, color: UIColor = .mainColor) -> Self {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        return self
    }
    
    @discardableResult
    func withTint(_ color: UIColor) -> Self {
        tintColor = color
        return self
    }
    
    @discardableResult
    func withClip() -> Self {
        clipsToBounds = true
        return self
    }
    
    @discardableResult
    func withCorner(_ value: CGFloat = 5) -> Self {
        layer.cornerRadius = abs(CGFloat(Int(value * 100)) / 100)
        // withClip()
        return self
    }
    
    @discardableResult
    func withBackColor(_ value: UIColor) -> Self {
        backgroundColor = value
        return self
    }
    
    @discardableResult
    func withAlpha(_ value: CGFloat) -> Self {
        alpha = value
        return self
    }
}

extension AppSwiftUI where Self: UIButton {
    @discardableResult
    func withText(_ value: String? = nil) -> Self {
        setTitle(value, for: .normal)
        return self
    }
    
    @discardableResult
    func withTitleColor(_ color: UIColor) -> Self {
        setTitleColor(color, for: .normal)
        return self
    }
    
    @discardableResult
    func withBackImage(_ value: UIImage) -> Self {
        setBackgroundImage(value, for: .normal)
        return self
    }
    
    @discardableResult
    func withImage(_ value: UIImage?) -> Self {
        setImage(value, for: .normal)
        return self
    }
    
    @discardableResult
    func withFont(_ value: UIFont = .mediumFont(of: 15)) -> Self {
        titleLabel?.font = value
        return self
    }
    
    @discardableResult
    func withTint(_ color: UIColor) -> Self {
        tintColor = color
        imageView?.tintColor = color
        return self
    }
    
    @discardableResult
    func withnderLineText() -> Self {
        // setTitle(text, for: .normal)
        // setTitleColor(textColor, for: .normal)
        // titleLabel?.font = UIFont(name: NeoSansFont.regular.rawValue, size: 15)
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedText = NSAttributedString(string: currentTitle!, attributes: attributes)
        titleLabel?.attributedText = attributedText
        return self
    }
}

extension AppSwiftUI where Self: UILabel {
    @discardableResult
    func withText(_ value: String? = nil) -> Self {
        text = value
        return self
    }
    
    @discardableResult
    func withFont(_ value: UIFont = UIConstants.mainLableFont) -> Self {
        font = value
        return self
    }
    
    @discardableResult
    func withTextColor(_ value: UIColor) -> Self {
        textColor = value
        return self
    }
    
    @discardableResult
    func withMultiLine() -> Self {
        numberOfLines = 0
        return self
    }
    
    @discardableResult
    func withLinesCount(_ value: Int) -> Self {
           numberOfLines = value
           return self
    }
    
    
    @discardableResult
    func withAlignment(_ value: NSTextAlignment) -> Self {
        textAlignment = value
        return self
    }
}

extension AppSwiftUI where Self: UITextField {
    @discardableResult
    func withText(_ value: String? = nil) -> Self {
        text = value
        return self
    }
    
    @discardableResult
    func withPlaceHolder(_ value: String? = nil) -> Self {
        placeholder = value
        return self
    }
    
    @discardableResult
    func withPlaceHolderColor(_ value: UIColor, holderText: String) -> Self {
        attributedPlaceholder = NSAttributedString(string: holderText, attributes: [NSAttributedString.Key.foregroundColor : value])
        return self
    }
    
    @discardableResult
    func withFont(_ value: UIFont = UIConstants.mainTextFieldFont) -> Self {
        font = value
        return self
    }
    
    @discardableResult
    func withTextColor(_ value: UIColor) -> Self {
        textColor = value
        return self
    }
    
    @discardableResult
    func withPadding(_ value: CGFloat) -> Self {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: 0))
        rightView = paddingView
        rightViewMode = .always

        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0,  width: value, height: 0))
        leftView = leftPaddingView
        leftViewMode = .always

        return self
    }
    
    @discardableResult
    func withLeadingImage(_ value: UIImage) -> Self {
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 40))
        mainView.layer.cornerRadius = 8
        
        let imageView = UIImageView(image: value)
        imageView.withClip()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        let padding: CGFloat = 10
        mainView.addSubview(imageView)
        imageView.fillSuperview(padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        leftViewMode = .always
        leftView = mainView
        return self
    }
    
    var phoneKeyboard: UITextField {
        keyboardType = .phonePad
        return self
    }
    
    var numPadboard: UITextField {
        keyboardType = .numberPad
        return self
    }
    
    var secure: UITextField {
        isSecureTextEntry = true
        return self
    }
    
    var centerAlignment: UITextField {
        textAlignment = .center
        return self
    }
}

extension AppSwiftUI where Self: UIStackView {
    func withVertical() -> Self {
        axis = .vertical
        return self
    }
    
    func withHorizontal() -> Self {
        axis = .horizontal
        return self
    }
    
    func withAlignment(_ value: UIStackView.Alignment) -> Self {
        alignment = value
        return self
    }
    
    func withPadding(_ value: UIEdgeInsets) -> Self {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = value
        return self
    }
    
    func withDistribution(_ value: UIStackView.Distribution) -> Self {
        distribution = value
        return self
    }
    
    func withSpacing(_ value: CGFloat) -> Self {
        spacing = value
        return self
    }
}

extension AppSwiftUI where Self: UIImageView {
    func withContentMode(_ value: UIView.ContentMode = .scaleAspectFit) -> Self {
        contentMode = value
        return self
    }
}

extension UIView: AppSwiftUI { }

struct UIConstants {
    static let mainLableFont: UIFont = .mediumFont(of: 16)
    static let mainTextFieldFont: UIFont = .mediumFont(of: 16)
}
