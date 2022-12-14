//
//  StatusCode.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// HTTP status code, not using Enum is due to extensibility concern, since Enum type can not be extend in Swift.
struct StatusCode: RawRepresentable, Equatable {
    
    let rawValue: Int
}

extension StatusCode {
    
    /// Test if a status means error, from WikiPedia definition.
    /// - Returns: NetworkError
    func testStatus() -> NetworkError? {
        if 100 ... 199 ~= rawValue {
            return .informationalResponse
        }
        
        if 200 ... 299 ~= rawValue {
            return nil
        }
        
        if 300 ... 399 ~= rawValue {
            return .redirection
        }
        
        if 400 ... 499 ~= rawValue {
            return .clientError
        }
        
        if 500 ... 599 ~= rawValue {
            return .serverError
        }
        
        return .unexpectedError(statusCode: rawValue)
    }
}
