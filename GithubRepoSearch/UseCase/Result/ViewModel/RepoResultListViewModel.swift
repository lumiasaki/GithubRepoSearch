//
//  RepoResultListViewModel.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation
import Combine

final class RepoResultListViewModel {
    
    /// Input of triggering the search, once user type in characters you should deliver those characters to this subject
    private(set) var keywordInput: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    
    /// Observe on this publisher to update your data source
    var repositories: AnyPublisher<[RepositoryDisplayItem], Never> {
        return repositoriesSubject.eraseToAnyPublisher()
    }
    
    /// Observe on this publisher to pop up an error if it be emitted
    var error: AnyPublisher<NetworkError?, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
        
    private var repositoriesSubject: CurrentValueSubject<[RepositoryDisplayItem], Never> = CurrentValueSubject([])
    private var errorSubject: PassthroughSubject<NetworkError?, Never> = PassthroughSubject()
    
    private var bag: Set<AnyCancellable> = Set()
    
    /// Initializer of the RepoResultListViewModel, in unit case you can inject a publisher to the view model to test the emitted values, in normal flow just leave parameter to be nil
    /// - Parameter networkPublisherProvider: Provider of network publisher, be used in unit test
    init(_ networkPublisherProvider: ((String) -> AnyPublisher<[Repository], NetworkError>)? = nil) {
        // process injected publisher and real network publisher
        let _networkPublisherProvider = networkPublisherProvider ??
        { keyword in
            return Future<[Repository], NetworkError> { promise in
                Task {
                    do {
                        let result = try await APIManager.shared.search.repository(keyword: keyword)
                        
                        promise(.success(result))
                    } catch {
                        promise(.failure(error as! NetworkError))
                    }
                }
            }.eraseToAnyPublisher()
        }
        
        let repositoriesStream = keywordInput
            .throttle(for: 2, scheduler: DispatchQueue.main, latest: true)
            .compactMap { $0 }
            .flatMap { keyword in
                return _networkPublisherProvider(keyword).materialize()
            }
            .share()
        
        repositoriesStream
            .values()
            .sink { [weak self] repositories in
                Logger.log("received \(repositories.count)", level: .info)
                self?.repositoriesSubject.send(repositories.map { RepositoryDisplayItem(repository: $0) })
            }
            .store(in: &bag)
        
        repositoriesStream
            .failures()
            .sink { [weak self] error in
                Logger.log("received error: \(error.localizedDescription)", level: .error)
                self?.errorSubject.send(error)
            }
            .store(in: &bag)
    }
}
