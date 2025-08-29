//
//  PrescriptionsEntity.swift
//  App
//
//  Created by Ahmed Taha on 13/02/2024.
//

import Foundation

struct PrescriptionsEntity: Codable {
    var id: Int?
    var status: String?
    var statusTrans: String?
    var images, files: [PrescriptionFileEntity]?
    var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, status, images, files
        case createdAt = "created_at"
        case statusTrans = "status_trans"
    }
}

struct PrescriptionFileEntity: Codable {
    let image: String?
}
