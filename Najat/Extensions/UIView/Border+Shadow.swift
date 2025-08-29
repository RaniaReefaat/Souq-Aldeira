//
//  Border+Shadow.swift
//  Captain One
//
//  Created by Mohamed Akl on 19/06/2022.
//  Copyright © 2022 Mohamed Akl. All rights reserved.
//

import UIKit

extension UIView {
    func setRadius(radius: CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    func setContainerViewRadius(radius: CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = false
        self.layer.masksToBounds = true
    }
    func setShadow(radius: CGFloat){
        self.layer.shadowColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1692630187)
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 13
        self.layer.shadowOpacity = 1
        self.layer.cornerRadius = radius
    }
}
class CircleImageView: UIImageView {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  override func layoutSubviews() {
    super.layoutSubviews()
//    self.layer.borderWidth = 1
    self.layer.masksToBounds = false
    self.layer.borderColor = UIColor.white.cgColor
    self.layer.cornerRadius = self.frame.size.width/2
    self.clipsToBounds = true
  }
}
