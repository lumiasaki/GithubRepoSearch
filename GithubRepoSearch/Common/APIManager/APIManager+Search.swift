//
//  APIManager+Search.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// Name space of the Search API cluster
struct SearchNamespace {
    
    fileprivate let base: APIManager
}

/// Sort method, be used in search request
enum SearchRepositorySort: String {
    
    case stars
    case forks
}

// MARK: - Public

extension SearchNamespace {
    
    /// Request repository with given keyword
    /// - Parameters:
    ///   - keyword: Keyword
    ///   - sort: Sort method
    ///   - pcursor: Current page, default is 1
    /// - Returns: Repositories or NetworkError
    func repository(keyword: String, sort: SearchRepositorySort = .stars, pcursor: Int = 1) async throws -> [Repository] {
        let params = generateParams(with: keyword, sort: sort, pcursor: pcursor)
        
        guard let request = Request.searchRepository(params: params) else {
            fatalError()
        }
        
        let result: SearchRepoResponse = try await URLSession.shared.fetch(request)
        
        return result.items ?? []
    }
}

// MARK: - Private

extension SearchNamespace {
    
    private func generateParams(with keyword: String, sort: SearchRepositorySort, pcursor: Int) -> [String : String] {
        var result: [String : String] = Dictionary()
        
        result["q"] = keyword
        result["sort"] = sort.rawValue
        result["page"] = String(pcursor)
        
        return result
    }
}

// MARK: - Entry Point

extension APIManager {
    
    var search: SearchNamespace {
        return SearchNamespace(base: self)
    }
}
