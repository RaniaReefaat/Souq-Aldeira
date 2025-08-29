//
//  TableViewExtension.swift
//  Captain One Driver
//
//  Created by Mohamed Akl on 19/06/2022.
//  Copyright © 2022 Mohamed Akl. All rights reserved.
//

import UIKit

extension UITableView {
    
    func setEmptyData(image: UIImage? ,title: String?, description: String? = nil) {
        let vc = NoDataViewController(frame: .zero)
        vc.setData(image: image, description: description, title: title)
        backgroundView = vc
    }
   
    func removeBackGroundView() {
        backgroundView = nil
    }
}

extension UICollectionView {
    func setEmptyData(image:UIImage,description:String ,title:String) {
        let vc = NoDataViewController(frame: .zero)
        vc.setData(image: image, description: description, title: title)
        backgroundView = vc
    }
    
    func removeBackGroundView() {
        backgroundView = nil
    }
}
