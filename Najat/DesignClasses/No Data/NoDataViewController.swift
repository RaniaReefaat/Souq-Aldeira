
//  NoDataViewController.swift
//  Captain One Driver
//
//  Created by Mohamed Akl on 19/06/2022.
//  Copyright © 2022 Mohamed Akl. All rights reserved.
//

import UIKit

class NoDataViewController: UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imageLogo: UIImageView!

//    private weak var delegate:NoDataViewControllerDelegate?
    
    func setData(image: UIImage?, description: String?,title:String?) {
        if image != nil {
            imageLogo.image = image
        }
        lblTitle.text = title
        lblDescription.text =  description
//        fadeIn()
    }
    
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        imageLogo.alpha = 0
        UIView.animate(withDuration: duration, animations: {
            self.imageLogo.alpha = 1.0
        })
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        commenInitialization()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commenInitialization()
    }

    func commenInitialization() {
        Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
       
    
    }
}
