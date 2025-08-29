//
//  CartRepository.swift
//  Najat
//
//  Created by mahroUS on 05/08/2567 BE.
//

import Foundation

struct CartRepository: CartRepoInterface {
   
    let network = CartNetwork()
    
    func getCartList() -> RequestPublisher<CartListEntityModel> {
        network.cartListAPI
            .makeRequest()
    }
  
    func showCart(cartID: Int) -> RequestPublisher<CartEntity> {
        network.showCartAPI
            .addPathVariables(path: "\(cartID)")
            .makeRequest()
    }
    
    func deleteItem(cartID: Int, itemID: Int) -> RequestPublisher<EmptyData> {
        network.removeItem
            .addPathVariables(path: "\(cartID)/item/\(itemID)")
            .makeRequest()
    }

    func addToCart(body: AddToCartBody) -> RequestPublisher<EmptyData> {
        network.addToCartAPI
            .makeRequest(with: body)
    }
    
    func makeCart(cartID: String, body: CheckCartBody) -> RequestPublisher<String> {
        network.makeCartAPI
            .addPathVariables(path: "\(cartID)/checkout")
            .makeRequest(with: body)
    }
    func checkCoupon(code: String, subtotal: String) -> RequestPublisher<CouponEntity> {
        network.checkCoupone
            .makeRequest(with: ["code": code, "subtotal": subtotal])
    }
}
