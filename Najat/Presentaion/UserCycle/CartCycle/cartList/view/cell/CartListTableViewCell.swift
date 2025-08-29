//
//  CartListTableViewCell.swift
//  Najat
//
//  Created by rania refaat on 21/07/2024.
//

import UIKit

class CartListTableViewCell: UITableViewCell {

    @IBOutlet private weak var marketLogoImageView: UIImageView!
    @IBOutlet private weak var marketNameLabel: AppFontLabel!
    @IBOutlet private weak var marketNumberLabel: AppFontLabel!
    @IBOutlet private weak var cartButton: AppFontButton!
   
    var actionShowCart: (() -> Void)?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    func configCell(with model: CartListDataModel) {
        marketLogoImageView.load(with: model.store.image)
        marketNameLabel.text = model.store.name
        let number = model.productsCount
        marketNumberLabel.text = "\(number)"
    }
    
    @IBAction func didTapCart(_ sender: Any) {
        actionShowCart?()
    }
}
