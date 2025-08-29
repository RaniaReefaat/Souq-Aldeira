//
//  AlertViewHandler.swift
//  Driver App
//
//  Created by youssef on 9/15/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import UIKit

// swiftlint:disable all

enum Theme {
    case success
    case warning
    case error
}

enum AlertTitles {
    case error
    case success
    case warning
    
    var theme: Theme {
        switch self {
        case .error:
            return .error
        case .success:
            return .success
        case .warning:
            return .warning
        }
    }
}

class AlertView: UIView {
    
    private let logoImageView = UIImageView()
    private let imageView = UIImageView()
    private let messageLabel = UILabel()
    
    private var message: String
    private var title: AlertTitles
    
    init(message: String, title: AlertTitles) {
        self.message = message
        self.title = title
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        switch title {
        case .success:
            backgroundColor = .clear
            imageView.image = #imageLiteral(resourceName: "Icon ionic-ios-checkmark").withRenderingMode(.alwaysOriginal)
            logoImageView.image = #imageLiteral(resourceName: "NSmallLogo").withRenderingMode(.alwaysOriginal)
        case .warning:
            backgroundColor = .clear
            imageView.image = #imageLiteral(resourceName: "danger").withRenderingMode(.alwaysOriginal)
            logoImageView.image = #imageLiteral(resourceName: "NSmallLogo").withRenderingMode(.alwaysOriginal)
        case .error:
            backgroundColor = .clear
            imageView.image = #imageLiteral(resourceName: "error").withRenderingMode(.alwaysOriginal)
            logoImageView.image = #imageLiteral(resourceName: "NWhiteLogo").withRenderingMode(.alwaysOriginal)
        }
        
        messageLabel.textColor = .white
        messageLabel.font = .mediumFont(of: 16)
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        
        let swipeToTop = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        swipeToTop.direction = .down
        
        addGestureRecognizer(swipeToTop)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.closeMe()
        }
    }
    
    @objc
    private func handleGesture(_ sender: UISwipeGestureRecognizer) {
        closeMe()
    }
    
    private func closeMe() {
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = .init(translationX: 0, y: 2000)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    fileprivate func layout() {
        let view = UIView()
        view.viewCornerRadius = 10
        
        switch title {
        case .success:
            view.backgroundColor = .hex("52B788")
        case .warning:
            view.backgroundColor = .hex("FFCC00")
        case .error:
            view.backgroundColor = .hex("EF233C")
        }
        
        let logoBackView = UIView()
        logoBackView.backgroundColor = .clear
        logoBackView.withSize(.init(all: 40))
        logoBackView.viewCornerRadius = 20
        
        logoBackView.addSubview(logoImageView)
        logoImageView.leadingAnchorSuperView(constant: 0)
        logoImageView.trailingAnchorSuperView(constant: 0)
        logoImageView.topAnchorSuperView(constant: 0)
        logoImageView.bottomAnchorSuperView(constant: 0)
        
        view.addSubview(logoBackView)
        logoBackView.centerYInSuperview()
        logoBackView.leadingAnchorSuperView(constant: 15)
        logoBackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10).isActive = true
        
        let imageViewBackView = UIView()
        imageViewBackView.backgroundColor = .clear
        imageViewBackView.withSize(.init(all: 24))
        imageViewBackView.viewCornerRadius = 12
        
        view.addSubview(imageViewBackView)
        imageViewBackView.centerYInSuperview()
        imageViewBackView.trailingAnchorSuperView(constant: 10)
        
        imageViewBackView.addSubview(imageView)
        imageView.centerXInSuperview()
        imageView.centerYInSuperview()
        
        view.addSubview(messageLabel)
        messageLabel.leadingAnchorToView(anchor: logoBackView.trailingAnchor, constant: 10)
        NSLayoutConstraint.activate([
//            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: imageViewBackView.leadingAnchor, constant: -10),
//            messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20)
        ])
        messageLabel.centerXInSuperview()
        messageLabel.centerYInSuperview()

        messageLabel.topAnchorSuperView(constant: 10)
        
        addSubview(view)
        view.leadingAnchorSuperView(constant: 24)
        view.trailingAnchorSuperView(constant: 24)
        view.topAnchorSuperView(constant: 10)
        view.bottomAnchorSuperView(constant: 0)
        
        view.layoutIfNeeded()
        layoutIfNeeded()
        
        transform = .init(translationX: 0, y: 2000)
        alpha = 1
        
        UIView.animate(withDuration: 1) {
            self.transform = .identity
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AlertViewHandler {
    
    private var window: UIWindow? {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return scene.windows.first
        }
        return nil
    }
    
    func showAlert(message: String, title: AlertTitles) {
        guard let window else { return }
        
        let safeAreaTop = UIApplication.shared.windows
            .filter{ $0.isKeyWindow }.first?.safeAreaInsets.top ?? 0
        
        let view = AlertView(message: message, title: title)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        window.addSubview(view)
        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            view.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: 0),
            // view.heightAnchor.constraint(equalToConstant: 100) //
        ])
        view.layout()
    }
}

// swiftlint:enable
