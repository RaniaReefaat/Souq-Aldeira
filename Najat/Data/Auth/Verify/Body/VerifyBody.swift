//
//  VerifyBody.swift
//  Najat
//
//  Created by rania refaat on 26/07/2024.
//

import Foundation

struct VerifyPhoneBody: JsonEncadable {
    var phone: String?
    let code: String
    let device_type: String = "ios"
    let device_token: String? = MessagingHandler.deviceToken
}
