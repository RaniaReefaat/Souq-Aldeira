//
//  UITabBar+.swift
//  Dukan
//
//  Created by Mohammed Balegh on 30/05/2023.
//

import UIKit

fileprivate let tabBarItemTag: Int = 10

extension UITabBar {
    public func addItemBadge(atIndex index: Int, count: Int) {
        guard let itemCount = self.items?.count, itemCount > 0 else {
            return
        }
        guard index < itemCount else {
            return
        }
        removeItemBadge(atIndex: index)
        
        let badgeView = UIView()
        badgeView.tag = tabBarItemTag + Int(index)
        badgeView.layer.cornerRadius = 8.5
        badgeView.backgroundColor = UIColor.hex("#FF4300")
        var text = "\(count)"
        if count > 9 {
            text = "+9"
        }
        let label = UILabel(text: text, font: .boldSystemFont(ofSize: 10), textColor: .white)
        label.textAlignment = .center
        
        let tabFrame = self.frame
        let percentX = (CGFloat(index) + 0.56) / CGFloat(itemCount)
        let x = (percentX * tabFrame.size.width).rounded(.up) + 4
        let y = (CGFloat(0.1) * tabFrame.size.height).rounded(.up) - 2
        badgeView.frame = CGRect(x: x, y: y, width: 17, height: 17)
        label.frame = CGRect(x: x + 1, y: y, width: 15, height: 15)
        addSubview(badgeView)
        addSubview(label)
    }
    
    @discardableResult
    public func removeItemBadge(atIndex index: Int) -> Bool {
        for subView in self.subviews {
            if subView.tag == (tabBarItemTag + index) {
                subView.removeFromSuperview()
                return true
            }
        }
        return false
    }
}
