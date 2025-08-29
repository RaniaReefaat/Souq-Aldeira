//
//  CategoryModel.swift
//  Najat
//
//  Created by rania refaat on 28/07/2024.
//

import Foundation

// MARK: - CategoryModel
struct CategoryModel: Codable {
    let status: Bool?
    let message: String?
    let data: [Category]?
}

// MARK: - Datum
struct Category: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let categoryID: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case categoryID = "category_id"
    }
}
