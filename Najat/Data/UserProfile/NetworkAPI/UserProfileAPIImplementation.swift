//
//  UserProfileAPIImplementation.swift
//  Najat
//
//  Created by rania refaat on 01/08/2024.
//

import Foundation

struct UserProfileDataSource {
    
    let getProfileApi: any RequestMaker<UserDataModel> = NetworkWrapper(url: .path("user/profile"), method: .get)
    
    let updateProfileApi: any RequestMaker<UserDataModel> = NetworkWrapper(url: .path("user/profile"), method: .post)

    let updateStoreProfileApi: any RequestMaker<UserDataModel> = NetworkWrapper(url: .path("store/profile"), method: .post)

    let logoutApi: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("user/logout"), method: .post)
    
    let getFollowingApi: any RequestMaker<[FollowingStoresModel]> = NetworkWrapper(url: .path("user/followings"), method: .get)

    let createStoreApi: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("user/create-store"), method: .post)

    let followStoreApi: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("user/following/store"), method: .post)
   
    let switchAccount: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("auth/switch-account"), method: .post)

    let getDeliveryPrice: any RequestMaker<[String]> = NetworkWrapper(url: .path("general/delivery-fees"), method: .get)

    let editUserProfile: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("user/profile"), method: .get)

    
    let updateProfilePhoneApi: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("user/phone/send-otp"), method: .post)
    
    let verifyProfilePhoneApi: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("user/phone/is-verified"), method: .post)

    
}
