//
//  CALayer+.swift
//  Estshara
//
//  Created by youssef on 11/1/20.
//

import UIKit

extension CALayer {
    func applySketchShadow(color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.19), alpha: Float = 0.2, x: CGFloat = 0, y: CGFloat = 3, blur: CGFloat = 16, spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
