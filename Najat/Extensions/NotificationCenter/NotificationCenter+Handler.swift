//
//  NotificationCenter+Handler.swift
//  App
//
//  Created by Ahmed Taha on 22/01/2024.
//

import Foundation

extension NSNotification.Name {
    static let changeCategoryId = NSNotification.Name("changeCategoryId")
    static let favoriteProductID = NSNotification.Name("favoriteProductID")
}

class NotificationPublisher {
    
    static func homeCategorySelectionPublisher(with id: Int) {
        NotificationCenter.default.post(name: .changeCategoryId, object: id)
    }
    
    static func favoriteProductPublisher(with id: Int) {
        NotificationCenter.default.post(name: .favoriteProductID, object: id)
    }
}
