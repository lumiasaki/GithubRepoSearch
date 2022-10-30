//
//  LogService.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// Underlying log service to drive logger
final class LogService {
    
    static let shared: LogService = LogService()
    
    private lazy var workerQueue: DispatchQueue = DispatchQueue.init(label: "com.zhutianren.log-service", attributes: [.concurrent])
    
    private(set) lazy var debugObservers: Set<AnyLogLevelObserver> = Set()
    private(set) lazy var infoObservers: Set<AnyLogLevelObserver> = Set()
    private(set) lazy var warnObservers: Set<AnyLogLevelObserver> = Set()
    private(set) lazy var errorObservers: Set<AnyLogLevelObserver> = Set()
    private(set) lazy var fatalObservers: Set<AnyLogLevelObserver> = Set()
    
    /// Register a log level observer to service, thread-safe.
    /// - Parameters:
    ///   - observer: Any type which conforms to LogLevelObserver.
    ///   - level: LogLevel.
    func register<T: LogLevelObserver>(observer: T, on level: LogLevel) {
        workerQueue.sync(flags: .barrier) {
            inject(observer: observer, to: level)
        }
    }
    
    /// Dispatch a message to let observers can consume, thread-safe.
    /// - Parameter message: LogMessage.
    func dispatch(message: LogMessage) {
        selectObservers(by: message.level).forEach { observer in
            self.workerQueue.sync {
                message.delegateQueue.async {
                    observer.consume(observed: message)
                }
            }
        }
    }
}

extension LogService {
    
    private func inject<T: LogLevelObserver>(observer: T, to level: LogLevel) {
        if level.contains(.debug) {
            debugObservers.insert(AnyLogLevelObserver(observer))
        }
        
        if level.contains(.info) {
            infoObservers.insert(AnyLogLevelObserver(observer))
        }
        
        if level.contains(.warning) {
            warnObservers.insert(AnyLogLevelObserver(observer))
        }
        
        if level.contains(.error) {
            errorObservers.insert(AnyLogLevelObserver(observer))
        }
        
        if level.contains(.fatal) {
            fatalObservers.insert(AnyLogLevelObserver(observer))
        }
    }
    
    private func selectObservers(by level: LogLevel) -> Set<AnyLogLevelObserver> {
        var result: Set<AnyLogLevelObserver> = Set()
                        
        if level.contains(.debug) {
            result.formUnion(debugObservers)
        }
        
        if level.contains(.info) {
            result.formUnion(infoObservers)
        }
        
        if level.contains(.warning) {
            result.formUnion(warnObservers)
        }
        
        if level.contains(.error) {
            result.formUnion(errorObservers)
        }
        
        if level.contains(.fatal) {
            result.formUnion(fatalObservers)
        }
        
        return result
    }
}
