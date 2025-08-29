//
//  PopupViewController.swift
//  Bro-Driver
//
//  Created by Youssef on 24/01/2023.
//

import UIKit

class PopupViewController: BaseController {
    
    let viewBack = UIView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        setupAction()
    }
    
    private func initUI() {
        view.backgroundColor = .clear
        view.insertSubview(viewBack, at: 0)
        viewBack.fillSuperview()
    }
    
    func setupAction() {
        let tab = UITapGestureRecognizer(target: self, action: #selector(viewBackTap))
        viewBack.addGestureRecognizer(tab)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewBack.fadeInBackground(duration: 0.35, after: 0.35, alpha: 0.5)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        viewBack.frame = view.frame
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewBack.fadeOutBackground()
    }
    
    @objc func viewBackTap() {
        dismiss(animated: true, completion: nil)
    }
}

extension UIView {
    
    /**
     fadeInBackground a view with a duration
     
     - parameter duration: The custom animation duration
     - parameter after: The duration before start animate
     - parameter alpha: The last alpha value
     - parameter color: The background color of view
     */
    func fadeInBackground(duration: TimeInterval = 1,
                after: TimeInterval = 0.25,
                alpha: CGFloat = 0.5,
                color backgroudColor: UIColor = .black) {
        self.backgroundColor = backgroudColor.withAlphaComponent(0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            UIView.animate(withDuration: duration, animations: {
                self.backgroundColor = backgroudColor.withAlphaComponent(alpha)
            })
        }
    }
    
    /**
     fadeOutBackground a view with a duration
     
     - parameter duration: The custom animation duration
     - parameter after: The duration before start animate
     - parameter alpha: The first alpha value
     - parameter color: The background color of view
     */
    func fadeOutBackground(duration: TimeInterval? = nil,
                   after: TimeInterval = 0.25,
                   alpha: CGFloat = 0.5,
                   color backgroudColor: UIColor = .black) {
        if let duration = duration {
            self.backgroundColor = backgroudColor.withAlphaComponent(alpha)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + after) {
                UIView.animate(withDuration: duration, animations: {
                    self.backgroundColor = backgroudColor.withAlphaComponent(0)
                })
            }
        } else {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(0)
        }
    }
}
