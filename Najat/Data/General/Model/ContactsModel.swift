//
//  ContactsModel.swift
//  Najat
//
//  Created by rania refaat on 21/08/2024.
//

import Foundation

// MARK: - QuestionsModelData
struct QuestionsModelData: Codable {
    let question, answer: String?
}

// MARK: - DataClass
struct ContactsModel: Codable {
    let phone: String?
    let twitter, instagram, snapchat, tiktok: String?
}
