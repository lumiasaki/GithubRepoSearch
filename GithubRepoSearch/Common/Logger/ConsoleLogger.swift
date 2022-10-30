//
//  ConsoleLogger.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// A pretty simple console logger for this submission, actually, you can create any complex logger with LogService.
struct ConsoleLogger: LogLevelObserver {
    
    var observerIdentifier: UUID = UUID()
    
    func consume(observed message: LogMessage) {
        print("\(message.timestamp) \(message.level.description): \(message.message)")
    }
}
