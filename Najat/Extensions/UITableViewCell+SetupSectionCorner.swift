//
//  UITableViewCell+SetupSectionCorner.swift
//  App
//
//  Created by Reda on 14/11/2023.
//

import UIKit

extension UITableViewCell {
    
    func setupSectionCorners(for tableView: UITableView, cornerRadius: CGFloat, indexPath: IndexPath) {
        var corners: UIRectCorner = []
        if indexPath.row == 0 {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
        }
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        ).cgPath
        layer.mask = maskLayer
    }
}
