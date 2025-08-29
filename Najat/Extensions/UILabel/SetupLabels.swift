//
//  SetupLabels.swift
//  App
//
//  Created by Ahmed Taha on 30/11/2023.
//

import UIKit

extension UILabel {
    
    func setupPriceStyle(with price: Double) {
        let currentPrice = String(format: "%.2f", price).components(separatedBy: ".")
        let priceBeforePoint = currentPrice[0]
        let priceAfterPoint = currentPrice[1]
        
        self.attributedText = NSMutableAttributedString(with: [
            .init(text: "\(priceBeforePoint).", font: .mediumFont(of: 24), color: .blackColor, alignment: .langTextAlignment),
            .init(text: priceAfterPoint + " ", font: .regularFont(of: 16), color: .blackColor, alignment: .langTextAlignment),
            .init(text: "SAR".localized, font: .regularFont(of: 16), color: .blackColor, alignment: .langTextAlignment)
        ])
    }
    
    func setupPriceWithSmallSize(with price: Double) {
        let currentPrice = String(format: "%.2f", price).components(separatedBy: ".")
        let priceBeforePoint = currentPrice[0]
        let priceAfterPoint = currentPrice[1]
        
        self.attributedText = NSMutableAttributedString(with: [
            .init(text: "\(priceBeforePoint).", font: .mediumFont(of: 16), color: .blackColor, alignment: .langTextAlignment),
            .init(text: priceAfterPoint + " ", font: .regularFont(of: 12), color: .blackColor, alignment: .langTextAlignment),
            .init(text: "SAR".localized, font: .regularFont(of: 12), color: .blackColor, alignment: .langTextAlignment)
        ])
    }
}

final class AppPrice {
    
    static func setupPrice(with price: Double) -> String {
        let currentPrice = String(format: "%.2f", price).components(separatedBy: ".")
        let priceBeforePoint = currentPrice[0]
        let priceAfterPoint = currentPrice[1]
        return "\(priceBeforePoint).\(priceAfterPoint) \("SAR".localized)"
    }
    
    static func setupPriceWithoutCurrency(with price: Double) -> String {
        let currentPrice = String(format: "%.2f", price).components(separatedBy: ".")
        let priceBeforePoint = currentPrice[0]
        let priceAfterPoint = currentPrice[1]
        return "\(priceBeforePoint).\(priceAfterPoint)"
    }
}
