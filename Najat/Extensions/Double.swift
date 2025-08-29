//
//  Double.swift
//  SaudiMarch
//
//  Created by Youssef on 10/5/22.
//  Copyright © 2022 Youssef. All rights reserved.
//

import SwiftUI

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension String {
//    var localized: String {
//        NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
//    }
}
