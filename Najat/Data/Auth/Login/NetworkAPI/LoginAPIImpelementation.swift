//
//  LoginAPIImplementation.swift
//  MyApp
//
//  Created by Mohammed Balegh on 08/11/2023.
//

import Foundation

struct LoginDataSource {
    let loginAPI: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("auth/send-otp"), method: .post)
}
