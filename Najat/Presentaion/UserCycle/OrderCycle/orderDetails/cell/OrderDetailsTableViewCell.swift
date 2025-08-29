//
//  OrderDetailsTableViewCell.swift
//  Najat
//
//  Created by rania refaat on 23/07/2024.
//

import UIKit

class OrderDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var productQuantityLabel: AppFontLabel!
    @IBOutlet weak var productPriceLabel: AppFontLabel!
    @IBOutlet weak var productNameLabel: AppFontLabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var containerImageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        containerImageView.setRadius(radius: 7)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(product: ProductItem){
        productImageView.load(with: product.product?.image)
        productNameLabel.text = product.product?.name
        productPriceLabel.text = product.total?.addCurrency
        productQuantityLabel.text = product.qty?.string
    }
}
