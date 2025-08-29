//
//  MyAccountsTableViewCell.swift
//  Najat
//
//  Created by rania refaat on 19/08/2024.
//

import UIKit

class MyAccountsTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: AppFontLabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var selectImageView: UIImageView!

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
