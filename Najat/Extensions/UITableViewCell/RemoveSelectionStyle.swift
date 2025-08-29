//
//  RemoveSelectionStyle.swift
//  App
//
//  Created by Ahmed Taha on 12/12/2023.
//

import UIKit

extension UITableViewCell {
    func removeSelectionStyle() {
        selectionStyle = .none
    }
}
import Foundation

import UIKit
//extension UITableView {
//    func scrollToBottom(animated: Bool = true) {
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(
//                row: self.numberOfRows(inSection:  self.numberOfSections - 1 ) - 1,
//                section: self.numberOfSections - 1)
//            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
//        }
//    }
//}
extension UITableView {

    func scrollToBottom(isAnimated:Bool = true){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            print(self.numberOfRows(inSection:  self.numberOfSections-1) - 1)
            print(self.numberOfSections - 1)

            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
            }
        }
    }

    func scrollToTop(isAnimated:Bool = true) {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: isAnimated)
           }
        }
    }

    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}


extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }

    func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }

    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }

}

extension UIViewController {
    func TableDesign(TVC: UITableView) {
        TVC.tableFooterView = UIView()
        TVC.separatorInset = .zero
        TVC.contentInset = .zero
    }
}


extension UITableView{
    func TableDesign() {
        self.tableFooterView = UIView()
        self.separatorInset = .zero
        self.contentInset = .zero
    }
}
