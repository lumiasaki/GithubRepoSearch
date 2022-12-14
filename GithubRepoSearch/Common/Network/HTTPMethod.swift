//
//  HTTPMethod.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// HTTPMethod, since Enum type in Swift can not be extend, here use Struct type instead.
struct HTTPMethod: RawRepresentable, Equatable {
    
    let rawValue: String
}

extension HTTPMethod {
    
    static let get: HTTPMethod = HTTPMethod(rawValue: "GET")
    static let post: HTTPMethod = HTTPMethod(rawValue: "POST")    
    static let put: HTTPMethod = HTTPMethod(rawValue: "PUT")
    static let delete: HTTPMethod = HTTPMethod(rawValue: "DELETE")
}
