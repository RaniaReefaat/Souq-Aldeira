//
//  MainProfileTableViewCell.swift
//  Najat
//
//  Created by rania refaat on 20/08/2024.
//

import UIKit

class MainProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var arrowImageView: FlipImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var lineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
//        containerView.applySketchShadow()

    }
    @objc func switchValueDidChange(_ sender: UISwitch) {
        print("")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configCell(data:ProfileData){
        nameLabel.text = data.title
        cellImageView.image = UIImage(named: data.profileImages.rawValue)

    }
    
}
