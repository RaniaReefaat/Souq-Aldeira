//
//  AsyncRequest.swift
//  Youssef
//
//  Created by Youssef on 7/14/22.
//  Copyright © 2022 Youssef. All rights reserved.
//

import Foundation
import Alamofire
import Combine

typealias RequestPublisher<T: Codable> = AnyPublisher<NetworkState<T>, Never>

protocol Network<T>: AnyObject {
    associatedtype T: Codable
    var request: RequestReusable { get }
    func asPublisher() -> RequestPublisher<T>
    func asPublisher(data: [UploadData]) -> RequestPublisher<T>
    func withBody(_ body: JsonEncadable?) -> Self
}

class AsyncRequest<T: Codable>: Network {
    
    public var request: RequestReusable
    private var interceptor: RequestInterceptor
    
    var statusCodeSeq: [Int] {
        get {
            var seq = Array(200..<499)
            seq.remove(at: 201)
            return seq
        }
    }
        
    init(request: RequestReusable, interceptor: RequestInterceptor = AppRequestInterceptor()) {
        self.request = request
        self.interceptor = interceptor
    }
    
    private lazy var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 60
        configuration.timeoutIntervalForRequest = 60
        return Session(configuration: configuration, interceptor: interceptor)
    }()
    
    func withBody(_ body: JsonEncadable?) -> Self {
        request.body = body
        return self
    }
    
    @discardableResult
    func asPublisher(data: [UploadData]) -> RequestPublisher<T> {
        sessionManager
            .upload(multipartFormData: {[weak self] multipartFormData in
                data.forEach {
                    print($0.mimeType)
                    multipartFormData.append($0.data ?? Data(), withName: $0.name, fileName: $0.fileName, mimeType: $0.mimeType)
                }
                
                for (key, value) in self?.request.body?.json ?? [:] {
                    if let stringValue = value as? String {
                        // No percent encoding, just convert to data directly
                        multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                    } else if let intValue = value as? Int {
                        // Convert the integer to a string and then to data
                        let stringValue = String(intValue)
                        multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                    } else {
                        print("Unsupported value type for key: \(key)")
                    }
                }
            }, with: request)
            .validate(statusCode: statusCodeSeq)
            .uploadProgress { (progress) in
#if DEBUG
                print(String(format: "%.1f", progress.fractionCompleted * 100))
#endif
            }
            .publishDecodable()
            .map({ NetworkState($0) })
            .eraseToAnyPublisher()
    }
    
    @discardableResult
    func asPublisher() -> RequestPublisher<T> {
        sessionManager
            .request(request)
            .validate(statusCode: statusCodeSeq)
            .publishDecodable()
            .map({ NetworkState($0) })
            .eraseToAnyPublisher()
    }
}
