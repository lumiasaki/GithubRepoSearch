//
//  LogMessage.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// Log message
struct LogMessage: Equatable {
    
    let level: LogLevel
    let message: String
    let timestamp: TimeInterval
    let delegateQueue: DispatchQueue
    
    init(level: LogLevel, message: String, timestamp: TimeInterval = Date().timeIntervalSince1970, delegateQueue: DispatchQueue = .main) {
        self.level = level
        self.message = message
        self.timestamp = timestamp
        self.delegateQueue = delegateQueue
    }
}
