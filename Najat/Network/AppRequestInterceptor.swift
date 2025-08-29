//
//  AppRequestInterceptor.swift
//  Youssef
//
//  Created by Youssef on 7/14/22.
//  Copyright © 2022 Youssef. All rights reserved.
//

import Foundation
import Alamofire

class AppRequestInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue(AppMainLang.appMainLang, forHTTPHeaderField: "x-localization")
        urlRequest.setValue("os", forHTTPHeaderField: "ios")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
//#if DEBUG
//        if let token = UserDefaults.userData?.token {
//            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
//#else
        if let token = UserDefaults.userData?.token {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
//#endif
//        urlRequest.setValue("Bearer 31|m5ZkiCZMp0T73VnfTK7zKRnmNGE5XNpk0L9EaSBK42284e07", forHTTPHeaderField: "Authorization")

        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        let statusCode = request.response?.statusCode
        if statusCode == 401 { AppWindowManger.openLogin() }
        completion(.doNotRetry)
    }
}
