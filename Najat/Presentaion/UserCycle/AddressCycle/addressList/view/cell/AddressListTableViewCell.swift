//
//  AddressListTableViewCell.swift
//  Najat
//
//  Created by rania refaat on 22/07/2024.
//

import UIKit

class AddressListTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(model: AddressEntity) {
        titleLabel.text = model.name
        bodyLabel.text = model.address
    }
}
