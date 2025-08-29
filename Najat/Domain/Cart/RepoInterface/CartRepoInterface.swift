//
//  CartRepoInterface.swift
//  Najat
//
//  Created by mahroUS on 05/08/2567 BE.
//

import Foundation

protocol CartRepoInterface {
    func getCartList() -> RequestPublisher<CartListEntityModel>
    func showCart(cartID: Int) -> RequestPublisher<CartEntity>
    func deleteItem(cartID: Int, itemID: Int) -> RequestPublisher<EmptyData>
    func addToCart(body: AddToCartBody) -> RequestPublisher<EmptyData>
    func makeCart(cartID: String, body: CheckCartBody) -> RequestPublisher<String>
    func checkCoupon(code: String, subtotal: String) -> RequestPublisher<CouponEntity>
}
