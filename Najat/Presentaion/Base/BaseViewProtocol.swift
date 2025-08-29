//
//  BaseView.swift
//  Torch
//
//  Created by youssef on 8/11/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

// swiftlint:disable all

protocol BaseViewProtocol: AnyObject {
    var activityIndicatorView: NVActivityIndicatorView { get }
    func startLoading()
    func stopLoading()
    func showAlert(with message: String, title: AlertTitles)
}

extension BaseViewProtocol where Self: UIViewController {
    func showAlert(with message: String, title: AlertTitles) {
        AlertViewHandler().showAlert(message: message, title: title)
    }
    
    @MainActor
    func startLoading() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = UIScreen.main.bounds.center
        activityIndicatorView.startAnimating()
    }
    
    func stopLoading() {
        activityIndicatorView.removeFromSuperview()
        activityIndicatorView.stopAnimating()
    }
}

// swiftlint:enable
