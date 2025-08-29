//
//  Object.swift
//  Son App
//
//  Created by youssef on 1/19/20.
//  Copyright © 2020 youssef. All rights reserved.
//

import Foundation

extension NSObject {
    class var className: String {
        "\(self)"
    }
    
    var jsonToString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func cast<T: Any>(to type: T.Type) -> T? {
        self as? T
    }
    
    func forceCast<T: Any>(to type: T.Type) -> T {
        self as! T
    }
}
