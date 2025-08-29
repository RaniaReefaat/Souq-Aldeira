//
//  HomeSliderCollectionViewCell.swift
//  Edrak
//
//  Created by rania refaat on 20/08/2023.
//

import UIKit

class HomeSliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(banner: Banners){
        imageView.load(with: banner.image)
        containerView.setRadius(radius: 16)

    }
}
