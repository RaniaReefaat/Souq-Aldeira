//
//  CGFloat+.swift
//  Dukan
//
//  Created by Ahmed Taha on 19/04/2023.
//

import Foundation

extension CGFloat {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension CGFloat {
    var string: String {
        "\(self)"
    }
    
    var int: Int {
        Int(self)
    }
}

extension Double {
    var cgFloat: CGFloat {
        CGFloat(self)
    }
    
    var int: Int {
        Int(self)
    }
}

extension Int {
    var cgFloat: CGFloat {
        CGFloat(self)
    }
}
