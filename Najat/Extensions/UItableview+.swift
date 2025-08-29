//
//  UItableview+.swift
//  Caberz
//
//  Created by Youssef on 12/10/20.
//

import UIKit


extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let section = numberOfSections
        if section > 0 {
            let row = numberOfRows(inSection: section - 1)
            if row > 0 {
                scrollToRow(at: IndexPath(row: row - 1, section: section - 1), at: .bottom, animated: animated)
            }
        }
    }
}

extension UITableView {
    func setNoData(text: String = "No Data Found".localize) {
        let lbl = UILabel(text: text, font: .mediumFont(of: 15) , textColor: .mainColor)
        lbl.textAlignment = .center
        self.backgroundView = lbl
    }
}

extension UITableView{
    func handleTableDesign() {
        self.tableFooterView = UIView()
        self.separatorInset = .zero
        self.contentInset = .zero
    }
}

extension UITableView {

    func registerHeaderFooter<T: UITableViewHeaderFooterView>(with: T.Type) {
        let identifier = String(describing: T.self)
        register(.init(nibName: identifier, bundle: .main), forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(with type: T.Type) -> T {
        let identifier = String(describing: T.self)
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? T else {
            fatalError("Error in cell")
        }
        return header
    }

}

class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

extension UICollectionViewCell {
    static var nib: UINib {
        return UINib(nibName:String(describing: self), bundle: nil)
    }
}
