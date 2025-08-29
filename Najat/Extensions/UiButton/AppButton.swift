//
//  AppButton.swift
//  App
//
//  Created by Reda on 21/11/2023.
//

import UIKit

extension UIButton {
    
    enum Types {
        case main
        case subMain
        case red
        
    }
    
    func setupButton(type: Types, with title: String) {
        switch type {
        case .main:
            setupMainButton(title: title)
        case .subMain:
            setupSubMainButton(title: title)
        case .red:
            setupRedButton(title: title)
        }
    }
    
    private func setupMainButton(title: String) {
        setupTitleButtonComponent(
            with: title,
            backgroundColor: .blue,
            titleColor: .mainColor,
            borderColor: .blue,
            fontSize: 16
        )
    }
    
    private func setupSubMainButton(title: String) {
        setupTitleButtonComponent(
            with: title,
            backgroundColor: .whiteColor,
            titleColor: .blue,
            borderColor: .blue,
            fontSize: 16
        )
    }
    
    private func setupRedButton(title: String) {
        setupTitleButtonComponent(with: title, backgroundColor: .whiteColor, titleColor: .red, borderColor: .red, fontSize: 16)
    }
    
    private func setupTitleButtonComponent(with title: String, backgroundColor: UIColor, titleColor: UIColor, borderColor: UIColor, fontSize: CGFloat) {
        layer.masksToBounds = true
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10
        self.backgroundColor = backgroundColor
        setTitleColor(titleColor, for: .normal)
        setTitle(title.localized, for: .normal)
        titleLabel?.font = .semiBoldFont(of: fontSize)
    }
}
