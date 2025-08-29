//
//  SelfSizedUITableView.swift
//  App
//
//  Created by Ahmed Taha on 11/12/2023.
//

import UIKit

class SelfSizedTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
}
