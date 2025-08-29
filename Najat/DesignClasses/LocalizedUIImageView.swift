//
//  LocalizedUIImageView.swift
//  Dukan
//
//  Created by Ahmed Taha on 06/03/2023.
//

import UIKit
//import MOLH

public class LocalizedUIImageView: UIImageView {
    public override func awakeFromNib() {
      super.awakeFromNib()
//      self.image = self.image?.flipIfNeeded()
    }
}

extension UIImage {
    public func flippedImage() -> UIImage?{
      if let _cgImag = self.cgImage {
        let flippedimg = UIImage(cgImage: _cgImag, scale:self.scale , orientation: UIImage.Orientation.upMirrored)
        return flippedimg
      }
      return nil
    }
}
