//
//  CollectionViewCellProtocol.swift
//  Wasselna-New
//
//  Created by Youssef on 15/11/2022.
//

import UIKit

protocol CollectionViewCellProtocol: UICollectionViewCell {
    associatedtype T
    func config(with data: T)
}
