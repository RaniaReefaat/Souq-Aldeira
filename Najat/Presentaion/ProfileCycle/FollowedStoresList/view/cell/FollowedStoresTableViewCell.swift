//
//  FollowedStoresTableViewCell.swift
//  Najat
//
//  Created by rania refaat on 02/08/2024.
//

import UIKit

class FollowedStoresTableViewCell: UITableViewCell {

    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(data: FollowingStoresModel){
        storeNameLabel.text = data.name
        storeImageView.load(with: data.image)
    }
    
}
