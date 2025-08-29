//
//  UIimageView+.swift
//  Globaly Bus
//
//  Created by youssef on 12/18/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func load(with url: String?, placeHolder: UIImage? = UIImage(named: "logoWithTitle") , cop: ((_ image: UIImage?) -> Void)? = nil) {
        
        image = placeHolder
        
        guard let urlString = url else { return }
        guard let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
        
        var activityIndicatorView: UIActivityIndicatorView
        
        if #available(iOS 13.0, *) {
            activityIndicatorView = UIActivityIndicatorView(style: .medium)
        } else {
            activityIndicatorView = UIActivityIndicatorView(style: .gray)
        }
        addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
        activityIndicatorView.startAnimating()
        activityIndicatorView.color = .mainColor
        activityIndicatorView.isHidden = false
        activityIndicatorView.hidesWhenStopped = true
        let options: SDWebImageOptions = [.continueInBackground]
        
        sd_setImage(with: url, placeholderImage: placeHolder, options: options, progress: nil) {[weak self] (image, error, cache, url) in
            activityIndicatorView.removeFromSuperview()
            if image == nil {
                self?.image = placeHolder
                cop?(nil)
            } else {
                self?.image = image
                cop?(image)
            }
        }
    }
}
class FlipImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        let language = L102Language.getCurrentLanguage()
        print(language)
        if language == "ar" {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        }else{
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}
