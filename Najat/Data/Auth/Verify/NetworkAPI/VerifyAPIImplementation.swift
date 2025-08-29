//
//  VerifyAPIImplementation.swift
//  Najat
//
//  Created by rania refaat on 26/07/2024.
//

import Foundation

struct VerifyDataSource {
    
    let verifyAPI: any RequestMaker<UserDataModel> = NetworkWrapper(url: .path("auth/verify"), method: .post)
    let resendVerifyCodeAPI: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("auth/send-otp"), method: .post)

}
