//
//  BinaryInteger+.swift
//  SaudiMarch
//
//  Created by Youssef on 05/10/2022.
//  Copyright © 2022 Youssef. All rights reserved.
//

import Foundation

extension BinaryInteger {
    var isEven: Bool { isMultiple(of: 2) }
    var isOdd: Bool { !isEven }
}
