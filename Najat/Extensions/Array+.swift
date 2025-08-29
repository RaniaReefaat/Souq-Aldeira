//
//  Array+.swift
//  Dinamo
//
//  Created by Youssef on 2/2/21.
//

import Foundation

extension Array {
    func getElement(at index: Int) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
    
    func item(at index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
