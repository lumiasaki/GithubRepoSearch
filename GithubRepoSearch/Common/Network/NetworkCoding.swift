//
//  NetworkCoding.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// Encoding types you can use.
enum NetworkEncoding {
    
    case json
}

extension Encodable {
    
    /// Get json data if it possible.
    /// - Returns: Data.
    func jsonData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}

/// Decoding types you can use.
enum NetworkDecoding<T: Decodable> {
    
    case json
}

extension NetworkDecoding {
    
    /// Parsing data to object type you inferred.
    /// - Parameter data: Data.
    /// - Returns: Object if not any failure.
    func parsing(_ data: Data) -> T? {
        switch self {
        case .json:
            return try? JSONDecoder().decode(T.self, from: data)
        }
    }
}
