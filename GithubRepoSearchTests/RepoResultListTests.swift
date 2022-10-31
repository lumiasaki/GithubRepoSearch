//
//  RepoResultListTests.swift
//  GithubRepoSearchTests
//
//  Created by tianren.zhu on 2022/10/30.
//

import XCTest
import Combine
@testable import GithubRepoSearch

final class RepoResultListTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRepoResultWithKeywordInput() throws {
        let networkPublisherProvider: (String, Int) -> AnyPublisher<(repositories: [Repository], totalCount: Int), NetworkError> = { keyword, _ in
            return Future<(repositories: [Repository], totalCount: Int), NetworkError> { promise in
                promise(.success(([
                    Repository(id: 1, name: keyword, owner: nil, htmlUrl: nil, repoDescription: nil, language: nil, stars: nil),
                    Repository(id: 2, name: "\(keyword)\(keyword)", owner: nil, htmlUrl: nil, repoDescription: nil, language: nil, stars: nil)
                ], 2)))
            }.eraseToAnyPublisher()
        }
        
        let viewModel = RepoResultListViewModel(networkPublisherProvider)
        
        let repositoryPublisher = viewModel.repositories
            .collect(2)
            .first()
        
        let keyword = "A"
        viewModel.keywordInput.send(keyword)
        
        let repositoryDisplayItems = try awaitPublisher(repositoryPublisher)
        XCTAssertTrue(repositoryDisplayItems.last?.repositories.count == 2)
        XCTAssertTrue(repositoryDisplayItems.last?.repositories[0].id == 1)
        XCTAssertTrue(repositoryDisplayItems.last?.repositories[1].id == 2)
        
        XCTAssertTrue(repositoryDisplayItems.last?.repositories[0].repositoryName == keyword)
        XCTAssertTrue(repositoryDisplayItems.last?.repositories[1].repositoryName == "\(keyword)\(keyword)")
        
        XCTAssertTrue(repositoryDisplayItems.last?.hasMore == false)
    }
    
    func testHasMore() throws {
        let networkPublisherProvider: (String, Int) -> AnyPublisher<(repositories: [Repository], totalCount: Int), NetworkError> = { keyword, _ in
            return Future<(repositories: [Repository], totalCount: Int), NetworkError> { promise in
                promise(.success(([
                    Repository(id: 1, name: keyword, owner: nil, htmlUrl: nil, repoDescription: nil, language: nil, stars: nil),
                    Repository(id: 2, name: "\(keyword)\(keyword)", owner: nil, htmlUrl: nil, repoDescription: nil, language: nil, stars: nil)
                ], 5)))
            }.eraseToAnyPublisher()
        }
        
        let viewModel = RepoResultListViewModel(networkPublisherProvider)
        
        let repositoryPublisher = viewModel.repositories
            .collect(2)
            .first()
        
        let keyword = "A"
        viewModel.keywordInput.send(keyword)
        
        let repositoryDisplayItems = try awaitPublisher(repositoryPublisher)
        XCTAssertTrue(repositoryDisplayItems.last?.repositories.count == 2)
        XCTAssertTrue(repositoryDisplayItems.last?.hasMore == true)
    }
    
    func testError() throws {
        let networkPublisherProvider: (String, Int) -> AnyPublisher<(repositories: [Repository], totalCount: Int), NetworkError> = { keyword, _ in
            return Future<(repositories: [Repository], totalCount: Int), NetworkError> { promise in
                promise(.failure(NetworkError.clientError))
            }.eraseToAnyPublisher()
        }
        
        let viewModel = RepoResultListViewModel(networkPublisherProvider)
        
        let errorPublisher = viewModel.error
            .collect(1)
            .first()
        
        let keyword = "A"
        viewModel.keywordInput.send(keyword)
        
        let errorPublisherItems = try awaitPublisher(errorPublisher)
        XCTAssertEqual(errorPublisherItems.first, NetworkError.clientError)
    }
    
    func testLoading() throws {
        let networkPublisherProvider: (String, Int) -> AnyPublisher<(repositories: [Repository], totalCount: Int), NetworkError> = { keyword, _ in
            return Future<(repositories: [Repository], totalCount: Int), NetworkError> { promise in
                promise(.success(([
                    Repository(id: 1, name: keyword, owner: nil, htmlUrl: nil, repoDescription: nil, language: nil, stars: nil),
                    Repository(id: 2, name: "\(keyword)\(keyword)", owner: nil, htmlUrl: nil, repoDescription: nil, language: nil, stars: nil)
                ], 5)))
            }.eraseToAnyPublisher()
        }
        
        let viewModel = RepoResultListViewModel(networkPublisherProvider)
        
        let loadingPublisher = viewModel.loading
            .dropFirst()    // first to be used on ui in the app
            .collect(2)
            .first()
        
        let keyword = "A"
        viewModel.keywordInput.send(keyword)
        
        let loadingPublisherItems = try awaitPublisher(loadingPublisher)
        XCTAssertTrue(loadingPublisherItems.count == 2)
        XCTAssertEqual(loadingPublisherItems.first, true)
        XCTAssertEqual(loadingPublisherItems.last, false)
    }
    
}
