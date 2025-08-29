//
//  Hashable+.swift
//  Estshara
//
//  Created by youssef on 11/10/20.
//

import Foundation

extension Hashable {
    var jsonToString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
