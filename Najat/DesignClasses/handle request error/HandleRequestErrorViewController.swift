//
//  HandleRequestErrorViewController.swift
//  Captain One Driver
//
//  Created by mahroUS on 12/10/2565 BE.
//  Copyright © 2565 BE Mohamed Akl. All rights reserved.
//

import UIKit

protocol callBackMethod {
    func callBack()
}
class HandleRequestErrorViewController: UIViewController {

    var delegate: callBackMethod?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tryAgainButton(_ sender: Any) {
     
        delegate?.callBack()
        self.removeAnimate()
    }
    
    @IBAction func disMissViewBtn(_ sender: Any) {
        self.removeAnimate()
    }
}
