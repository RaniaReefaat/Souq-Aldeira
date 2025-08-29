//
//  EditUserProfileBody.swift
//  Najat
//
//  Created by rania refaat on 24/08/2024.
//

import Foundation

struct EditUserProfileBody: JsonEncadable {
    
    var name: String?
    var phone: String?
    var bio: String?
    var receive_notifications: Int?
    
}
