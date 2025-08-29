//
//  NotificationTableViewCell.swift
//  Edrak
//
//  Created by rania refaat on 25/08/2023.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        containerView.setShadow(radius: 6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(data: NotificationItemData) {
        titleLabel.text = data.title
        bodyLabel.text = data.body

    }
}
