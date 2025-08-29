//
//  CoordinatorProtocol.swift
//  App
//
//  Created by Ahmed Taha on 28/12/2023.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {

    var presentedView: UIViewController? { get set }
    
    func push(_ view: UIViewController)
    func present(_ view: UIViewController, fullScreen: Bool)
    func customPresent(_ view: UIViewController)
    func crossDissolve(_ view: UIViewController)
    func pop()
    func dismiss()
    func showAlert(message: String, title: AlertTitles)
    func openCategoriesTab()
    func openCartTab()
    func openOffersTab()
    func playVideo(with url: String)
}
