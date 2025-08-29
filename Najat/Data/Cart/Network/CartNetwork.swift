//
//  CartNetwork.swift
//  Najat
//
//  Created by mahroUS on 05/08/2567 BE.
//

import Foundation

struct CartNetwork {
    let cartListAPI: any RequestMaker<CartListEntityModel> = NetworkWrapper(url: .path("cart"), method: .get)
    let showCartAPI: any RequestMaker<CartEntity> = NetworkWrapper(url: .path("cart/"), method: .get)
    let removeItem: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("cart/"), method: .delete)
    let addToCartAPI: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("cart"), method: .post)
    let checkCoupone:  any RequestMaker<CouponEntity> = NetworkWrapper(url: .path("cart/check-coupon"), method: .post) 
    let makeCartAPI: any RequestMaker<String> = NetworkWrapper(url: .path("cart/"), method: .post)
}

