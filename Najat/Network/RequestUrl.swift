//
//  RequestUrl.swift
//  Youssef
//
//  Created by Youssef on 7/14/22.
//  Copyright © 2022 Youssef. All rights reserved.
//

import Foundation

public enum RequestUrl {
    case full(String)
    case path(String)
    
    public var value: String {
        switch self {
        case .full(let url):
            return url
        case.path(let path):
            return Constants.baseUrl + path
        }
    }
}
