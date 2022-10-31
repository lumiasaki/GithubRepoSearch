//
//  APIManager.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// API environment of this app, to request Github API
struct GithubRepoSearchAPIEnvironment: EnvironmentProtocol {
    
    var host: String = "api.github.com"
    var commonHeaders: [String : String] = [
        "Accept": "application/vnd.github+json",
        "Authorization": "Bearer \(NetworkConstant.token.rawValue.decodeBase64String()!)"   // if we can not get token from base64, just crash, it's a fatal error
    ]
    var commonQueries: [URLQueryItem]?
}

/// A manager to handle all api request, in order to gain namespaces of the specific scenario request, we can make extensions on the APIManager just like APIManager+Search did
final class APIManager {
    
    /// Singleton of the APIManager, you should always use it
    static let shared: APIManager = APIManager()        
    
    /// Current API environment
    private(set) var environment: EnvironmentProtocol
    
    init(_ environment: EnvironmentProtocol = GithubRepoSearchAPIEnvironment()) {
        self.environment = environment
        
        // inject api environment to URLSession.shared
        URLSession.shared.environment = environment
    }
}
