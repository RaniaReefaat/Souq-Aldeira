//
//  TableViewCellProtocol.swift
//  Wasselna-Client
//
//  Created by rania refaat on 20/11/2022.
//

import UIKit

protocol TableViewCellProtocol: UITableViewCell {
    associatedtype T
    func config(with data: T)
}
