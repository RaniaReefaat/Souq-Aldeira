//
//  PaymentMethodTableViewCell.swift
//  Najat
//
//  Created by mahroUS on 07/08/2567 BE.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
   
    @IBOutlet private weak var paymentImageView: UIImageView!
    @IBOutlet private weak var selectImageView: UIImageView!
    @IBOutlet private weak var nameLabel: AppFontLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        // Initialization code
    }

    func configCell(with model: PaymentsEntity) {
//        paymentImageView.load(with: model.key)
        selectImageView.image = (model.isSelected ?? false) ? .unCheck : nil
        nameLabel.text = (model.name)
    }
}
