//
//  BaseViewController.swift
//  BaseProject
//
//  Created by youssef on 7/28/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseController: UIViewController, BaseViewProtocol {
    
    lazy var activityIndicatorView = NVActivityIndicatorView(
        frame: .init(x: 0, y: 0, width: 80, height: 80),
        type: .ballClipRotate,
        color: .mainColor,
        padding: .zero
    )
    
    private lazy var emptyView: EmptyView = {
        let emptyView = EmptyView()
        emptyView.withHeight(300)
        emptyView.withWidth(view.frame.width - 40)
        return emptyView
    }()

    var tabBar: TabBarViewController? {
        tabBarController as? TabBarViewController
    }
    
    let coordinator: CoordinatorProtocol = Coordinator()
    var cancellable = AppBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator.presentedView = self
        sink()
        getData()
    }

    func sink() {

    }

    func getData() {
        
    }
    
    func handleScreenState<T>(_ state: ScreenState<T>) {
        switch state {
        case .ideal:
            self.stopLoading()
        case .loading:
            self.startLoading()
        case .success:
            self.stopLoading()
            self.view.endEditing(true)
        case .failure(let error):
            self.stopLoading()
            self.view.endEditing(true)
            self.showAlert(with: error, title: .error)
        case .successWith(let message):
            self.view.endEditing(true)
            self.showAlert(with: message, title: .success)
        }
    }
    
    func showEmptyView(with type: EmptyViewTypes) {
        emptyView.isHidden = false
        emptyView.setupView(with: type)
        view.addSubview(emptyView)
        emptyView.centerXInSuperview()
        emptyView.centerYInSuperview()
    }
    
    func removeEmptyView() {
        emptyView.isHidden = true
    }
}
