//
//  RepoResultListViewModel.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import Foundation
import Combine

/// View model of RepoResultListViewController
final class RepoResultListViewModel {
    
    /// Input of triggering the search, once user type in characters you should deliver those characters to this subject
    private(set) var keywordInput: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    
    /// Observe on this publisher to update your data source
    var repositories: AnyPublisher<(repositories: [RepositoryDisplayItem], hasMore: Bool), Never> {
        return repositoriesSubject.eraseToAnyPublisher()
    }
    
    /// Observe on this publisher to pop up an error if it be emitted
    var error: AnyPublisher<NetworkError?, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    /// Observe on this publisher to determine loading state
    var loading: AnyPublisher<Bool, Never> {
        return loadingSubject.eraseToAnyPublisher()
    }
    
    /// Observe this publisher to navigate to repository detail page by given url
    var jumpToRepositoryDetail: AnyPublisher<URL, Never> {
        return jumpToRepositoryDetailSubject.eraseToAnyPublisher()
    }
    
    private var repositoriesSubject: CurrentValueSubject<(repositories: [RepositoryDisplayItem], hasMore: Bool), Never> = CurrentValueSubject(([], false))
    private var errorSubject: PassthroughSubject<NetworkError?, Never> = PassthroughSubject()
    private var loadingSubject: CurrentValueSubject<Bool, Never> = CurrentValueSubject(true)
    private var jumpToRepositoryDetailSubject: PassthroughSubject<URL, Never> = PassthroughSubject()
    
    /// The page of request
    private var pcursor: CurrentValueSubject<Int, Never> = CurrentValueSubject(1)
    
    private var bag: Set<AnyCancellable> = Set()
    
    /// Initializer of the RepoResultListViewModel, in unit case you can inject a publisher to the view model to test the emitted values, in normal flow just leave parameter to be nil
    /// - Parameter networkPublisherProvider: Provider of network publisher, be used in unit test
    init(_ networkPublisherProvider: ((String, Int) -> AnyPublisher<(repositories: [Repository], totalCount: Int), NetworkError>)? = nil) {
        
        // process injected publisher and real network publisher
        let _networkPublisherProvider = networkPublisherProvider ??
        { keyword, pcursor in
            return Future<(repositories: [Repository], totalCount: Int), NetworkError> { promise in
                Task {
                    do {
                        let (repositories, totalCount) = try await APIManager.shared.search.repository(keyword: keyword, pcursor: pcursor)
                        
                        promise(.success((repositories, totalCount)))
                    } catch {
                        promise(.failure(error as! NetworkError))
                    }
                }
            }.eraseToAnyPublisher()
        }
        
        // keyword throttled input publisher
        let keyword = keywordInput
            .dropFirst()
            .removeDuplicates()
            .throttle(for: 0.3, scheduler: DispatchQueue.main, latest: true)
            .compactMap { $0 }
        
        // once keyword changed, assign pcursor to default value
        keyword
            .sink { [weak self] k in
                self?.pcursor.value = 1
            }
            .store(in: &bag)
        
        // for logger
        pcursor.sink { p in
            Logger.log("change pcursor to \(p)", level: .info)
        }
        .store(in: &bag)
        
        // once pcursor changed ( 1. keyword changed, 2. request next page ), trigger the network request
        let repositoriesStream = pcursor
            .dropFirst()
            .map { [weak self] pcursor in
                return _networkPublisherProvider(self?.keywordInput.value ?? "", pcursor)
                    .materialize()
            }
            .switchToLatest()
            .share()
        
        // turn out the loading states
        repositoriesStream
            .map { _ in false }
            .sink { [weak self] loading in
                self?.loadingSubject.send(loading)
            }
            .store(in: &bag)
        
        // process success of network request ( due to materialize() )
        repositoriesStream
            .values()
            .sink { [weak self] repositoriesInfo in
                guard let `self` = self else {
                    return
                }
                
                let previousRepositoryDisplayItems = self.repositoriesSubject.value.repositories
                                
                let nextRepositoryDisplayItems = repositoriesInfo.repositories.map { RepositoryDisplayItem(repository: $0) }
                
                let currentTotalCount = previousRepositoryDisplayItems.count + nextRepositoryDisplayItems.count
                
                let hasMore = repositoriesInfo.totalCount > currentTotalCount
                
                Logger.log("received \(repositoriesInfo.repositories.count)", level: .info)
                
                if self.pcursor.value == 1 {
                    self.repositoriesSubject.send((nextRepositoryDisplayItems, hasMore))
                    
                    return
                }
                
                let duplicatesRemoved = (previousRepositoryDisplayItems + nextRepositoryDisplayItems).removingDuplicates()
                self.repositoriesSubject.send((duplicatesRemoved, hasMore))
            }
            .store(in: &bag)
        
        // process failure of network request ( due to materialize())
        repositoriesStream
            .failures()
            .sink { [weak self] error in
                Logger.log("received error: \(error.localizedDescription)", level: .error)
                self?.errorSubject.send(error)
                self?.repositoriesSubject.send(([], false))
            }
            .store(in: &bag)
    }
}

extension RepoResultListViewModel {
    
    /// Call this method when reach to the end of list
    func tryRequestNextPageIfNeeded() {
        guard repositoriesSubject.value.hasMore, !loadingSubject.value else {
            return
        }
        
        let currentPage = pcursor.value
        pcursor.send(currentPage + 1)
    }
    
    /// Select repository to jump to detail page ( home page of the repository )
    /// - Parameter indexPath: IndexPath
    func selectRepository(at indexPath: IndexPath) {
        guard indexPath.item < repositoriesSubject.value.repositories.count else {
            Logger.log("try to select indexPath: \(indexPath), out of bounds", level: .error)
            return
        }
        
        let selectedRepository = repositoriesSubject.value.repositories[indexPath.item]
        let urlString = selectedRepository.underlyingRepository.htmlUrl
        
        if let url = URL(string: urlString ?? "") {
            jumpToRepositoryDetailSubject.send(url)
        }
    }
}
