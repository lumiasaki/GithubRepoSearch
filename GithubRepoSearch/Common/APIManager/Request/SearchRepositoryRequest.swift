//
//  SearchRepositoryRequest.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

extension Request where ResponseType == SearchRepoResponse {
    
    /// Create request structure for search repository
    /// - Parameter params: Parameters of the request
    /// - Returns: Request of search repository
    static func searchRepository(params: [String : String?]?) -> Self? {
        return Request(endpoint: Endpoint(path: "/search/repositories", params: params), method: .get)
    }
}
