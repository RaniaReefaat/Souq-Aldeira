//
//  UIView+Styles.swift
//  App
//
//  Created by Ahmed Taha on 16/11/2023.
//

import UIKit

extension UIView {
    
    @IBInspectable var topCornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    
    @IBInspectable var bottomCornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    
    @IBInspectable var couponCornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
        }
    }
    
    
    @IBInspectable var isCircular: Bool {
        get {
            return layer.cornerRadius == bounds.width / 2.0
        }
        set {
            if newValue {
                layer.cornerRadius = bounds.width / 2.0
                clipsToBounds = true
            } else {
                layer.cornerRadius = 0
                clipsToBounds = false
            }
        }
    }
}

extension UIView {
    func addDashedBorder() {
        let color = UIColor.blue.cgColor
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: (frameSize.width / 2), y: (frameSize.height / 2))
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [4, 4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 15).cgPath
        self.layer.addSublayer(shapeLayer)
    }
}
