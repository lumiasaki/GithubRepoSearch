//
//  LogLevel.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// Log level structure, OptionSet
struct LogLevel: OptionSet, Hashable {
        
    var rawValue: UInt
    
    static let debug: LogLevel = LogLevel(rawValue: 1)
    static let info: LogLevel = LogLevel(rawValue: 1 << 1)
    static let warning: LogLevel = LogLevel(rawValue: 1 << 2)
    static let error: LogLevel = LogLevel(rawValue: 1 << 3)
    static let fatal: LogLevel = LogLevel(rawValue: 1 << 4)
    
    static let all: LogLevel = [.debug, .info, .warning, .error, .fatal]
}

extension LogLevel: CustomStringConvertible {
    
    var description: String {
        var result: [String] = Array()
        
        if contains(.debug) {
            result.append("debug")
        }
        
        if contains(.info) {
            result.append("info")
        }
        
        if contains(.warning) {
            result.append("warning")
        }
        
        if contains(.error) {
            result.append("error")
        }
        
        if contains(.fatal) {
            result.append("fatal")
        }
        
        return "[\(result.joined(separator: ","))]"
    }
}
