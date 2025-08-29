//
//  ConfirmOrderTableViewCell.swift
//  Najat
//
//  Created by rania refaat on 21/07/2024.
//

import UIKit

class ConfirmOrderTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var containerImageView: UIView!
    
    @IBOutlet private weak var nameLabel: AppFontLabel!
    @IBOutlet private weak var priceLabel: AppFontLabel!
    @IBOutlet private weak var qntLabel: AppFontLabel!
    @IBOutlet private weak var itemImageView: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        containerImageView.setRadius(radius: 7)
    }
    
    func configCell(with model: ItemEntity) {
        itemImageView.load(with: model.product?.image)
        nameLabel.text = model.product?.name
        priceLabel.text = model.price
        qntLabel.text = model.qty?.string
    }
    
}
