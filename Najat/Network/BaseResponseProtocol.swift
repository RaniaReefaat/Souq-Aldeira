//
//  BaseResponseProtocol.swift
//  Youssef
//
//  Created by Youssef on 16/12/2021.
//  Copyright © 2021 Youssef. All rights reserved.
//


import Foundation

protocol BaseResponseProtocol: Codable {
    associatedtype NetworkModel: Codable
    var data: NetworkModel? { get set }
    var isSuccess: Bool { get }
    var message: String? { get }
    var status: Bool? { get }
    var paginate: Paginate? {get}
}

extension BaseResponseProtocol {
    var isSuccess: Bool {
        // return true
        return status ?? false
    }
}

public struct BaseResponse<T: Codable>: BaseResponseProtocol {
    public var message: String?
    public var status: Bool?
    public var data: T?
    var paginate: Paginate?
}

public struct Meta: Codable {
    let currentPage, from, lastPage: Int?
    let path: String?
    let perPage, to, total: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case path
        case perPage = "per_page"
        case to, total
    }
}
// MARK: - Paginate
struct Paginate: Codable {
    let total, count, perPage: Int?
    let nextPageURL, prevPageURL: String?
    let currentPage, totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case total, count
        case perPage = "per_page"
        case nextPageURL = "next_page_url"
        case prevPageURL = "prev_page_url"
        case currentPage = "current_page"
        case totalPages = "total_pages"
    }
}

public struct EmptyData: Codable { }
