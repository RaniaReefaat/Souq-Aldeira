//
//  RegisterAPIImplementation.swift
//  Najat
//
//  Created by rania refaat on 26/07/2024.
//

import Foundation

struct RegisterDataSource {
    let registerAPI: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("auth/register"), method: .post)
}
