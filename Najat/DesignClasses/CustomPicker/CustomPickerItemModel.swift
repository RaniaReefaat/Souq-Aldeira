//
//  CustomPickerItemModel.swift
//  App
//
//  Created by Mohammed Balegh on 03/01/2024.
//

import Foundation

class CustomPickerItemModel: CustomPickerItemProtocol {
    
    init(id: String, value: String, isSelected: Bool = false, leadingImageUrl: String? = nil) {
        self.id = id
        self.value = value
        self.isSelected = isSelected
        self.leadingImageUrl = leadingImageUrl
    }
    
    var id: String
    var value: String
    var isSelected: Bool = false
    var leadingImageUrl: String?
}

class countriesPickerItemModel: CustomPickerItemProtocol {
    
    init(country: CountriesModel) {
        self.id = country.id.string
        self.value = country.name ?? ""
        self.leadingImageUrl = country.image
    }
    
    var id: String
    var value: String
    var isSelected: Bool = false
    var leadingImageUrl: String?
}
import Foundation

struct CountriesModel: Codable {
    let id: Int
    let name, phoneCode: String?
    let showPhoneCode: String?
    let image: String?
    let shortName: String?
    let phoneNumberLimit: Int?
    var isSelected: Bool = false
    
    init(entity: CountriesEntity?) {
        id = entity?.id ?? 0
        name = entity?.name ?? ""
        phoneCode = entity?.phoneCode ?? ""
        showPhoneCode = entity?.phoneCode ?? ""
        image = entity?.image ?? ""
        shortName = entity?.shortName ?? ""
        phoneNumberLimit = entity?.phoneNumberLimit ?? 0
    }
}
import Foundation

struct CountriesEntity: Codable {
    let id: Int
    let name, slug, nationality, phoneCode: String?
    let showPhoneCode: String?
    let image: String?
    let shortName: String?
    let phoneNumberLimit, nationalIDLimit: Int?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, nationality
        case phoneCode = "phone_code"
        case showPhoneCode = "show_phone_code"
        case image
        case shortName = "short_name"
        case phoneNumberLimit = "phone_number_limit"
        case nationalIDLimit = "national_id_limit"
        case createdAt = "created_at"
    }
}
