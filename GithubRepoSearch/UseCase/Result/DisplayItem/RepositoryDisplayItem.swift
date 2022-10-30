//
//  RepositoryDisplayItem.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// The structure to be used to show ui
struct RepositoryDisplayItem: Identifiable, Hashable, Equatable {
    
    /// Repository structure instance
    let underlyingRepository: Repository
    
    /// The identifier of repository
    var id: Int { underlyingRepository.id }
    
    /// Repository name
    var repositoryName: String? { underlyingRepository.name }
    
    /// Profile photo of owner of repository
    var ownerIconImageUrlString: String? { underlyingRepository.owner?.avatarUrl }
    
    /// Owner name
    var ownerName: String? { underlyingRepository.owner?.userName }
    
    /// Description of repository
    var repositoryDescription: String? { underlyingRepository.repoDescription }
    
    /// Language
    var language: String? { underlyingRepository.language }
    
    /// Stars
    var stars: String? { underlyingRepository.stars?.formattedNumberString }
    
    init(repository: Repository) {
        self.underlyingRepository = repository
    }
}
