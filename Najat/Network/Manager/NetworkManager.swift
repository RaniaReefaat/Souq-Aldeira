//
//  File.swift
//  
//
//  Created by Mohammed Balegh on 07/11/2023.
//

import Alamofire

class NetworkWrapper<T: Codable>: RequestMaker {
    var network: any Network<T> = AsyncRequest<T>(request: NetworkRequest(url: RequestUrl.path("any"), method: .get))
    
    init(url: RequestUrl, method: HTTPMethod) {
        network = AsyncRequest<T>(request: NetworkRequest(url: url, method: method))
    }
}
