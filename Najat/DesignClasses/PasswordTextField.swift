//
//  PasswordTextField.swift
//  App
//
//  Created by Ahmed Taha on 12/11/2023.
//

import UIKit

final class PasswordTextField: AppTextField {
    
    private var passwordButtonImage: UIImage {
        isSecureTextEntry ? (UIImage.back.withRenderingMode(.alwaysTemplate)) : (UIImage.back.withRenderingMode(.alwaysTemplate))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        isSecureTextEntry = true
        
        let showPasswordButton = UIButton(type: .system)
        showPasswordButton.setImage(passwordButtonImage, for: .normal)
        showPasswordButton.tintColor = .gray
        
        let view = UIView()
        view.addSubview(showPasswordButton)
        showPasswordButton.fillSuperview(padding: .init(0, side: 10))
        showPasswordButton.addTarget(self, action: #selector(showPasswordButtonAction(_:)), for: .touchUpInside)
        rightViewMode = .always
        rightView = view
    }
    
    @objc 
    private func showPasswordButtonAction(_ sender: UIButton) {
        isSecureTextEntry.toggle()
        sender.setImage(passwordButtonImage, for: .normal)
    }
}
