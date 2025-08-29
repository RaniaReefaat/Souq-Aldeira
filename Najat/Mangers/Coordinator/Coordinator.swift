//
//  Coordinator.swift
//  App
//
//  Created by Ahmed Taha on 28/12/2023.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

final class Coordinator: CoordinatorProtocol {
    
    weak var presentedView: UIViewController?
    
    func push(_ view: UIViewController) {
        presentedView?.navigationController?.pushViewController(view, animated: true)
    }
    
    func present(_ view: UIViewController, fullScreen: Bool) {
        if fullScreen { view.modalPresentationStyle = .fullScreen }
        presentedView?.present(view, animated: true, completion: nil)
    }
    
    func customPresent(_ view: UIViewController) {
        view.modalPresentationStyle = .custom
        presentedView?.present(view, animated: true)
    }
    
    func crossDissolve(_ view: UIViewController) {
        view.modalPresentationStyle = .fullScreen
        view.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.presentedView?.present(view, animated: true)
        }
    }
    
    func pop() {
        presentedView?.navigationController?.popViewController(animated: true)
    }
    
    func dismiss() {
        presentedView?.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(message: String, title: AlertTitles) {
        presentedView?.view.endEditing(true)
        AlertViewHandler().showAlert(message: message, title: title)
    }
    
    func openCategoriesTab() {
        openSpecificTab(with: 1)
    }
    
    func openCartTab() {
        openSpecificTab(with: 2)
    }
    
    func openOffersTab() {
        openSpecificTab(with: 3)
    }
    
    private func openSpecificTab(with index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            weak var keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            guard let tabBar = keyWindow?.rootViewController as? TabBarViewController else { return }
            tabBar.selectedIndex = index
        }
    }
    
    func playVideo(with url: String) {
        let urlWithoutSpacing = url.replacingOccurrences(of: " ", with: "%20")
        guard let videoURL = URL(string: urlWithoutSpacing) else {
            showAlert(message: "something_went_wrong".localized, title: .error)
            return
        }
        let player = AVPlayer(url: videoURL)
        let playerController = AVPlayerViewController()
        playerController.player = player
        presentedView?.present(playerController, animated: true) { playerController.player?.play() }
    }
}
