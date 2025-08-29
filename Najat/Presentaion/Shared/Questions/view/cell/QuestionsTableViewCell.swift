//
//  QuestionsTableViewCell.swift
//  WeHire
//
//  Created by rania refaat on 11/02/2024.
//

import UIKit

class QuestionsTableViewCell: UITableViewCell {

    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(data: QuestionsModelData){
        questionLabel.text = data.question
        answerLabel.text = data.answer
    }
}
