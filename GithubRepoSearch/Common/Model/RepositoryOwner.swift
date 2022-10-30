//
//  RepositoryOwner.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// Represent the owner structure of the repository
struct RepositoryOwner: Codable, Identifiable, Hashable, Equatable {
    
    /// Identifier of the owner
    var id: Int
    
    /// Name of the owner, could be used to show the ui
    var userName: String?
    
    /// Owner's profile photo
    var avatarUrl: String?
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case userName = "login"
        case avatarUrl = "avatar_url"
    }
}
