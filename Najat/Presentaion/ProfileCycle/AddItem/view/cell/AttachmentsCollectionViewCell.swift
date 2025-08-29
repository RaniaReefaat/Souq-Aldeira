//
//  AttachmentsCollectionViewCell.swift
//  Rasan
//
//  Created by rania refaat on 30/06/2024.
//

import UIKit

class AttachmentsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var addImageView: UIView!
    @IBOutlet weak var videoImageView: UIImageView!

    var selectedButtonTapped : (()->Void)?
    var deletedButtonTapped : (()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        imageContainerView.setRadius(radius: 20)
    }

    @IBAction func selectButtonTapped(_ sender: UIButton) {
        selectedButtonTapped?()
    }
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        deletedButtonTapped?()
    }
}
