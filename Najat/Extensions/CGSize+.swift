//
//  CGSize+.swift
//  Estshara
//
//  Created by youssef on 11/1/20.
//

import UIKit

extension CGSize {
    init(all: CGFloat) {
        self.init(width: all, height: all)
    }
}

extension UIEdgeInsets {
    init(_ side: CGFloat) {
        self.init(top: side, left: side, bottom: side, right: side)
    }
    
    init(_ top: CGFloat, side: CGFloat) {
        self.init(top: top, left: side, bottom: top, right: side)
    }
}

extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}
