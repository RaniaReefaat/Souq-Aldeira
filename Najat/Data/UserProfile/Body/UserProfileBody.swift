//
//  UserProfileBody.swift
//  Najat
//
//  Created by rania refaat on 01/08/2024.
//

import Foundation

struct UpdateUserProfileBody: JsonEncadable {
    
    var phone: String?
    var name: String?
    var bio: String?
    var receive_notifications: Int?
    var lang: String?
    var email: String?
    var delivery_fee: String?
    var whatsapp: String?
}
