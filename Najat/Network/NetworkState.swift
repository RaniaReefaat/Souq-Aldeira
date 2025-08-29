//
//  NetworkState.swift
//  Youssef
//
//  Created by Youssef on 7/14/22.
//  Copyright © 2022 Youssef. All rights reserved.
//

import Alamofire

enum NetworkState<T: Codable> {
    case success(BaseResponse<T>?)
    case fail(AppError)
    
    var data: T? {
        switch self {
        case .success(let data):
            return data?.data
        default: return nil
        }
    }
    
    var error: AppError? {
        switch self {
        case .fail(let error):
            return error
        default: return nil
        }
    }
    
    var isSuccess: Bool {
        switch self {
        case .success(let baseResponse):
            return baseResponse?.isSuccess ?? false
        case .fail:
            return false
        }
    }
    
    init(_ response: DataResponse<BaseResponse<T>, AFError>) {
        switch response.result {
        case .success(let model):
            if model.isSuccess {
                self = .success(model)
            } else if let error = model.message {
                self = .fail(MyAppError.businessError(error))
            } else {
                self = .fail(MyAppError.networkError)
            }
            
        case .failure(let error):
#if DEBUG
            debugPrint("Model Name: \(String(describing: T.self)) has request error", error.asAFError?.errorDescription ?? "", error.localizedDescription, error.failureReason ?? "", error.localizedDescription, "With URL: ", response.request?.url?.absoluteString ?? "")
#endif
            self = .fail(MyAppError.networkError)
        }
    }
    
    func result() -> Result<T, MyAppError> {
        switch self {
        case .success(let data):
            guard let data = data?.data else {
                if T.self == EmptyData.self {
                    return .success(EmptyData() as! T)
                } else {
                    return .failure(.businessError(data?.message ?? MyAppError.networkError.localizedDescription))
                }
            }
            return .success(data)
        case .fail(let error):
            return .failure(.businessError(error.validatorErrorAssociatedMessage))
        }
    }
    
    func resultWithMessage() -> Result<BaseResponse<T>, MyAppError> {
        switch self {
        case .success(let data):
            var newData = data
            return .success(data ?? BaseResponse())
        case .fail(let error):
            return .failure(.businessError(error.validatorErrorAssociatedMessage))
        }
    }
    
    func resultWithMeta() -> Result<DataResponseWithMeta<T>, MyAppError> {
        switch self {
        case .success(let data):
            if let model = data?.data {
                return .success(DataResponseWithMeta(data: model, paginate: data?.paginate))
            } else {
                return .failure(.businessError(data?.message ?? MyAppError.networkError.localizedDescription))
            }
        case .fail(let error):
          return .failure(.businessError(error.validatorErrorAssociatedMessage))
        }
      }
}

struct DataResponseWithMeta<T: Codable> {
    let data: T
    let paginate: Paginate?
}
