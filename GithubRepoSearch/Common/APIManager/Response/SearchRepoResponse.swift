//
//  SearchRepoResponse.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// Response structure of https://api.github.com/search/repositories
struct SearchRepoResponse: Codable, Hashable, Equatable {
    
    /// Count of result
    var totalCount: Int?
    
    /// Current page repositories
    var items: [Repository]?
        
    /// Error message
    var message: String?
    
    private enum CodingKeys: String, CodingKey {
        
        case totalCount = "total_count"
        case items
    }
}
