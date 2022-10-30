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
        let networkPublisherProvider: (String) -> AnyPublisher<[Repository], NetworkError> = { keyword in
            return Future<[Repository], NetworkError> { promise in
                promise(.success([
                    Repository(id: 1, name: keyword, owner: nil, htmlUrl: nil, repoDescription: nil, language: nil, stars: nil),
                    Repository(id: 2, name: "\(keyword)\(keyword)", owner: nil, htmlUrl: nil, repoDescription: nil, language: nil, stars: nil)
                ]))
            }.eraseToAnyPublisher()
        }
        
        let viewModel = RepoResultListViewModel(networkPublisherProvider)
        
        let repositoryPublisher = viewModel.repositories
            .collect(2)
            .first()
        
        let keyword = "A"
        viewModel.keywordInput.send(keyword)
        
        let repositoryDisplayItems = try awaitPublisher(repositoryPublisher)
        XCTAssertTrue(repositoryDisplayItems.last?.count == 2)
        XCTAssertTrue(repositoryDisplayItems.last?[0].id == 1)
        XCTAssertTrue(repositoryDisplayItems.last?[1].id == 2)
        
        XCTAssertTrue(repositoryDisplayItems.last?[0].repositoryName == keyword)
        XCTAssertTrue(repositoryDisplayItems.last?[1].repositoryName == "\(keyword)\(keyword)")
    }
    
}
