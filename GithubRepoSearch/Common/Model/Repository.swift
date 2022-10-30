//
//  Repository.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// Structure of Repository, since there are too many fields in Github API response, I just pick some relevant fields of them to build the ui
struct Repository: Codable, Identifiable, Hashable, Equatable {
    
    /// Identifier of repository
    var id: Int
    
    /// The name of repository
    var name: String?
    
    /// Owner of the repository
    var owner: RepositoryOwner?
    
    /// The html address of the repository, we can use it to jump to repository detail
    var htmlUrl: String?
    
    /// The description of the repository
    var repoDescription: String?
    
    /// Main programming language of the repository
    var language: String?
    
    /// Star count
    var stars: Int?
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case owner
        case htmlUrl = "html_url"
        case repoDescription = "description"
        case language
        case stars = "stargazers_count"
    }
}
