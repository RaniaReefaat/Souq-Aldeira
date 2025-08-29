//
//  PaymentViewController.swift
//  Loopz
//
//  Created by Ahmed Taha on 23/07/2024.
//

import UIKit
import WebKit

enum PaymentStatusTypes: String {
    case success
    case fail
}

final class PaymentViewController: UIViewController {
    
    @IBOutlet private weak var navigationView: NavigationView!
    @IBOutlet private weak var webView: WKWebView!
    
    private var paymentURL: String
    
    init(paymentURL: String) {
        self.paymentURL = paymentURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Setup Views
private extension PaymentViewController {
    func setupViews() {
        openPayment()
        webView.navigationDelegate = self
        addNotifyButton()
        setTitle(AppStrings.cart.message)
    }
    
    func openPayment() {
        guard let url = URL(string: paymentURL) else { return }
        webView.load(.init(url: url))
    }
}

// MARK: - WKNavigationDelegate Handling
extension PaymentViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let currentURL = webView.url else { return }
        print(currentURL)
        setupSuccessPay(currentURL)
    }
    
    private func setupSuccessPay(_ url: URL) {
        guard url.absoluteString.contains(PaymentStatusTypes.success.rawValue) else { return }
        AppWindowManger.openTabBar()
    }
}
