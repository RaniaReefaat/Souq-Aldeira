//
//  ScreenState.swift
//  Youssef
//
//  Created by Youssef on 7/14/22.
//  Copyright © 2022 Youssef. All rights reserved.
//

import Foundation
import Combine

public typealias ScreenPublisher<T> = AnyPublisher<ScreenState<T>, Never>

public enum ScreenState<T>: Equatable {
    public static func == (lhs: ScreenState<T>, rhs: ScreenState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.ideal, .ideal):
            return true
        case (.loading, .loading):
            return true
        case (.success, .success):
            return true
        case (.successWith, .successWith):
            return true
        case (.failure, .failure):
            return true
        default:
            return false
        }
    }
    
    case ideal
    case loading
    case success(T)
    case successWith(message: String)
    case failure(String)
    
    var error: String? {
        switch self {
        case .failure(let value):
            return value
        default: return nil
        }
    }
    
    var data: T? {
        switch self {
        case .success(let value):
            return value
        default: return nil
        }
    }
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        } else {
            return false
        }
    }
}
