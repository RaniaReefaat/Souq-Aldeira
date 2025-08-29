//
//  UserOrdersListTableViewCell.swift
//  Najat
//
//  Created by rania refaat on 20/08/2024.
//

import UIKit

class UserOrdersListTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: AppFontLabel!
    @IBOutlet weak var timeLabel: AppFontLabel!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: AppFontLabel!
    @IBOutlet weak var requestsNumberLabel: AppFontLabel!
    @IBOutlet weak var productsCountLabel: AppFontLabel!
    @IBOutlet weak var containerImageView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        containerImageView.setRadius(radius: 7)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configCell(order: OrdersModelData){
        timeLabel.text = order.createdAt
        storeImageView.load(with: order.store?.image)
//        storeNameLabel.text = order.store?.name
        storeNameLabel.text = "#\(order.id ?? 0)"
        productsCountLabel.text = order.productsCount?.string
        requestsNumberLabel.text = order.total?.addCurrency
        statusLabel.text = order.statusTranslated
        
//        switch order.status {
//        case .new:
//            statusLabel.textColor = .yellow
//        case .accepted:
//            statusLabel.textColor = .red
//        case .delivered:
//            statusLabel.textColor = .green
//        case .none:
//            break
//        }
    }
}
