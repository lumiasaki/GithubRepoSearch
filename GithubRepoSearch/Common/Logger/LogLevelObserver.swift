//
//  LogLevelObserver.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation

/// A type which can listen to LogMessage in LogService
protocol LogLevelObserver {
    
    /// Identifier of observer you should provide, used to as key
    var observerIdentifier: UUID { get }
    
    /// When observer receives a message, this method will be called
    /// - Parameter message: LogMessage
    func consume(observed message: LogMessage)
}

/// Type erasure type for LogLevelObserver, make it conforms to Hashable possible
class AnyLogLevelObserver: LogLevelObserver {
        
    private let wrappedObserverIdentifier: UUID
    private let consumeBlock: (_ information: LogMessage) -> Void
    
    var observerIdentifier: UUID { wrappedObserverIdentifier }
    
    init<T: LogLevelObserver>(_ wrapped: T) {        
        self.wrappedObserverIdentifier = wrapped.observerIdentifier
        self.consumeBlock = wrapped.consume(observed:)
    }
    
    func consume(observed message: LogMessage) {
        consumeBlock(message)
    }
}

/// The Observers will be store in a set, so here we need to make LogLevelObserver hashable
extension AnyLogLevelObserver: Hashable {
    
    static func == (lhs: AnyLogLevelObserver, rhs: AnyLogLevelObserver) -> Bool {
        return lhs.wrappedObserverIdentifier == rhs.wrappedObserverIdentifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(observerIdentifier)
    }
}
