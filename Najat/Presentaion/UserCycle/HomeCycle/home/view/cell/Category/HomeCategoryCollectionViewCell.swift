//
//  HomeCategoryCollectionViewCell.swift
//  Najat
//
//  Created by rania refaat on 24/06/2024.
//

import UIKit

class HomeCategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var allCategoryView: UIView!
    @IBOutlet weak var categoryImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configCell(category: Category){
        categoryNameLabel.text = category.name
        categoryImageView.load(with: category.image)
    }

}
