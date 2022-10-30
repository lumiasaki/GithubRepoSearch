//
//  Endpoint.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// Structure to represent Endpoint, you can use it to build Endpoints in strong-type way.
struct Endpoint {
        
    let path: String
    let params: [String : String?]?
    
    init(path: String, params: [String : String?]? = nil) {
        self.path = path
        self.params = params
    }
}

extension Endpoint {
    
    func queryItems() -> [URLQueryItem]? {
        return params?.map { URLQueryItem(name: $0, value: $1) }
    }
}
