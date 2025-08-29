//
//  StoreRequestsTableViewCell.swift
//  Najat
//
//  Created by rania refaat on 01/09/2024.
//

import UIKit

class StoreRequestsTableViewCell: UITableViewCell {

    @IBOutlet weak var clientNameLabel: AppFontLabel!
    @IBOutlet weak var orderNumberLabel: AppFontLabel!
    @IBOutlet weak var productsNumberLabel: AppFontLabel!
    @IBOutlet weak var timeLabel: AppFontLabel!
    @IBOutlet weak var acceptButton: AppFontButton!

    var acceptOrderTapped : (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func acceptOrderButtonTapped(_ sender: AppFontButton) {
        acceptOrderTapped?()
    }
    
   func configCell(order: OrdersModelData) {
       clientNameLabel.text = order.user?.name
       orderNumberLabel.text = order.id?.string
       timeLabel.text = order.createdAt
       productsNumberLabel.text = order.productsCount?.string
       let status = order.status ?? .new
       switch status {
       case .new:
           acceptButton.isHidden = false
       default:
           acceptButton.isHidden = true
       }
    }
}
