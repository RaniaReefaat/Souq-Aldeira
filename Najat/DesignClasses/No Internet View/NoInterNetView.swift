//
//  NoInterNetView.swift
//  Captain One Driver
//
//  Created by Mohamed Akl on 19/06/2022.
//  Copyright © 2022 Mohamed Akl. All rights reserved.
//


import UIKit

protocol NoInternetDelegate {
    func reloadData()
}

class NoInterNetView: UIView {
    
    @IBOutlet weak var laTitle: UILabel!
    @IBOutlet weak var laDesc: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var errorImage: UIImageView!
    
    var delegate: NoInternetDelegate?
    var errorType: ErrorViewType = .noInternet
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commenInitialization()
    }
    
    init(frame: CGRect, error:ErrorViewType) {
        super.init(frame: frame)
        self.errorType = error
        commenInitialization()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commenInitialization()
    }

    func commenInitialization() {
        Bundle.main.loadNibNamed("NoInterNet", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        displayScreenData()
        button.isEnabled = true
    }
    
    func displayScreenData() {
        if errorType.haveBtn  {
            button.isHidden = false
        }else{
            button.isHidden = true
        }
        laTitle.text = errorType.title
        laDesc.text = errorType.desc
    }
    
    @IBAction func tryAgain(_: UIButton) {
        delegate?.reloadData()
    }
}
