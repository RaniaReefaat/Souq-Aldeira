//
//  BannerModel.swift
//  Najat
//
//  Created by rania refaat on 28/07/2024.
//

import Foundation

// MARK: - BannerModel
struct BannerModel: Codable {
    let status: Bool?
    let message: String?
    let data: [Banners]?
}

// MARK: - Datum
struct Banners: Codable {
    let id: Int?
    let image: String?
    let url: String?
}
