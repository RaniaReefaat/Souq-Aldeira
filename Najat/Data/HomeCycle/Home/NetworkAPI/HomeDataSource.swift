//
//  HomeDataSource.swift
//  Najat
//
//  Created by rania refaat on 28/07/2024.
//

import Foundation

struct HomeDataSource {
    
    let categoryAPI: any RequestMaker<UserDataModel> = NetworkWrapper(url: .path("auth/verify"), method: .post)
    let bannersAPI: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("auth/send-otp"), method: .post)
    let productsAPI: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("auth/send-otp"), method: .post)


}
