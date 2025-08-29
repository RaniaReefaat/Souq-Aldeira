//
//  OrderListTableViewCell.swift
//  Najat
//
//  Created by rania refaat on 23/07/2024.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
