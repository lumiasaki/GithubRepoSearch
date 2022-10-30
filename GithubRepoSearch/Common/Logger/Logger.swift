//
//  Logger.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// A simple logger to wrap LogService in.
struct Logger {
    
    /// Log a message with some specific levels.
    /// - Parameters:
    ///   - message: The content of message.
    ///   - level: The level you want the message be in OptionSet type, will be listened by LogLevelObserver you registered previously while configuring LogService.
    static func log(_ message: String, level: LogLevel, _ name: String = #function) {
        LogService.shared.dispatch(message: LogMessage(level: level, message: "[\(name)]-\(message)"))
    }
}
