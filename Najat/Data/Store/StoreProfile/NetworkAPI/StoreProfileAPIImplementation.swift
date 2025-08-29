//
//  StoreProfileAPIImplementation.swift
//  Najat
//
//  Created by rania refaat on 03/09/2024.
//

import Foundation

struct StoreProfileDataSource {
    
    let getProfileApi: any RequestMaker<UserDataModel> = NetworkWrapper(url: .path("store/profile"), method: .get)
    
    let updateProfileApi: any RequestMaker<UserDataModel> = NetworkWrapper(url: .path("store/profile"), method: .post)
    
    let removeFollowerApi: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("store/remove-follower"), method: .post)

    let acceptOrderApi: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("store/order"), method: .post)

    let getOrderApi: any RequestMaker<OrdersModel> = NetworkWrapper(url: .path("store/orders"), method: .get)

    let getFollowers: any RequestMaker<[FollowingStoresModel]> = NetworkWrapper(url: .path("store/followers"), method: .get)

    
}
