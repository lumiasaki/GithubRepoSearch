//
//  HomeViewController.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import UIKit

class HomeViewController: UIViewController {

    private lazy var searchController = {
        let repoResultListViewModel = RepoResultListViewModel()
        let repoResultListViewController = RepoResultListViewController(viewModel: repoResultListViewModel)
        
        let controller = UISearchController(searchResultsController: repoResultListViewController)
        controller.searchResultsUpdater = repoResultListViewController
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUp()
    }
}

// MARK: - Private

extension HomeViewController {
    
    private func setUp() {
        title = "Search"
        
        navigationItem.searchController = searchController
    }
}

