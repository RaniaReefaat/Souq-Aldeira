//
//  EmptyViewTypes.swift
//  Loopz
//
//  Created by Ahmed Taha on 18/06/2024.
//

import UIKit

enum EmptyViewTypes {
    case cart
    case address
    case network
    case products
    case orders
    case userProducts

}

// MARK: - Setup EmptyView Images
extension EmptyViewTypes {
    var image: UIImage {
        switch self {
        case .cart:
            return UIImage(named: "NRedLogo") ?? UIImage()
        case .address:
            return UIImage(named: "NRedLogo") ?? UIImage()
        case .products:
            return UIImage(named: "No Results") ?? UIImage()
        case .orders:
            return UIImage(named: "NRedLogo") ?? UIImage()
        case .network:
            return UIImage(named: "NRedLogo") ?? UIImage()
        case .userProducts:
            return  UIImage()
        }
    }
}

// MARK: - Setup EmptyView Bodies
extension EmptyViewTypes {
    var body: String {
        switch self {
        case .cart:
            return ""
        case .address:
            return ""
        case .network:
            return "Empty Data"
        case .products:
            return "Sorry, there are no products in this section at the moment. You can browse other sections."
        case .orders:
            return ""
        case .userProducts:
            return ""
        }
    }
}

// MARK: - Setup EmptyView Titles
extension EmptyViewTypes {
    var title: String {
        switch self {
        case .cart:
            return "Cart is empty".localized
        case .address:
            return "There is no addresses".localized
        case .network:
            return "Empty Data"
        case .products:
            return "There is no products"
        case .orders:
            return "You don't have any order"
        case .userProducts:
            return "You don't have any products"
        }
    }
}
