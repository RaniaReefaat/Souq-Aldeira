//
// RequestReusable.swift
// SaudiMarch
//
// Created by Youssef on 19/10/2022.
// Copyright © 2022 Youssef. All rights reserved.
//

import Foundation
import Alamofire
import Combine

public protocol RequestReusable: Alamofire.URLRequestConvertible, AnyObject {
    var body: JsonEncadable? { get set }
    func addPathVariables(path: [String])
}

public class NetworkRequest: RequestReusable {
    
    public init(url: RequestUrl, method: HTTPMethod) {
        self.urlReq = url
        self.method = method
        switch method {
        case .get:
            self.encoding = .url
        default:
            self.encoding = .json
        }
    }
    
    public var body: JsonEncadable?
    
    private let urlReq: RequestUrl
    private let method: HTTPMethod
    private let encoding: RequestEncodingType
    private var pathVariables = ""
    
    public func addPathVariables(path: [String]) {
        pathVariables = path.joined(separator: "/")
    }
    
    public func asURLRequest() throws -> URLRequest {
        var urlString = urlReq.value.appending(pathVariables).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if !Validator.isUserLoggedIn {
            switch method {
            case .post, .delete:
                if let guestToken = UserDefaults.token {
                    urlString += "?guest_token=\(guestToken)"
                } else {
                    let guestToken = GuestToken.randomToken(length: 40)
                    UserDefaults.token = guestToken
                    urlString += "?guest_token=\(guestToken)"
                }
                handleGuestTokenInBody()
            case .get:
                handleGuestTokenInBody()
                break
            default:
                break
            }
        }
        
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return try encoding.value.encode(urlRequest, with: body?.json.compactMapValues{ $0 })
    }
    
    fileprivate func handleBodyGuestToken(_ guestToken: String) {
        if body.isNotNil {
            var body = self.body?.json
            body?["guest_token"] = guestToken
            self.body = body?.compactMapValues { $0 }
        } else {
            body = ["guest_token": guestToken]
        }
    }
    
    private func handleGuestTokenInBody() {
        if !Validator.isUserLoggedIn {
            if let guestToken = UserDefaults.token {
                handleBodyGuestToken(guestToken)
            } else {
                let guestToken = GuestToken.randomToken(length: 40)
                UserDefaults.token = guestToken
                handleBodyGuestToken(guestToken)
            }
        }
    }
}

class GuestToken {
    static func randomToken(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
