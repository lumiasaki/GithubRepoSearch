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
    
    private lazy var workspaceTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .headline)
        view.textColor = .label
        view.text = LocalizationConstant.Home.myWorkspace.rawValue.localized()
        return view
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
        title = LocalizationConstant.Home.searchTitle.rawValue.localized()
        
        navigationItem.searchController = searchController
        
        view.addSubview(workspaceTitleLabel)
        NSLayoutConstraint.activate([
            workspaceTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            workspaceTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            workspaceTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        let fakeViewsContainer = UIView()
        fakeViewsContainer.translatesAutoresizingMaskIntoConstraints = false
        fakeViewsContainer.layer.borderColor = UIColor.systemGray6.cgColor
        fakeViewsContainer.layer.borderWidth = 5
        fakeViewsContainer.layer.cornerRadius = 8
        
        view.addSubview(fakeViewsContainer)
        NSLayoutConstraint.activate([
            fakeViewsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fakeViewsContainer.topAnchor.constraint(equalTo: workspaceTitleLabel.bottomAnchor, constant: 20),
            fakeViewsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fakeViewsContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        let containerOfEntries = UIStackView()
        containerOfEntries.translatesAutoresizingMaskIntoConstraints = false
        containerOfEntries.axis = .vertical
        containerOfEntries.alignment = .leading
        containerOfEntries.distribution = .fillEqually
        containerOfEntries.spacing = 10
        containerOfEntries.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        containerOfEntries.isLayoutMarginsRelativeArrangement = true
        
        fakeViewsContainer.addSubview(containerOfEntries)
        NSLayoutConstraint.activate([
            containerOfEntries.leadingAnchor.constraint(equalTo: fakeViewsContainer.leadingAnchor),
            containerOfEntries.topAnchor.constraint(equalTo: fakeViewsContainer.topAnchor),
            containerOfEntries.trailingAnchor.constraint(equalTo: fakeViewsContainer.trailingAnchor),
            containerOfEntries.bottomAnchor.constraint(equalTo: fakeViewsContainer.bottomAnchor)
        ])
        
        for _ in 0 ... 10 {
            containerOfEntries.addArrangedSubview(fakeEntryView(widthRatio: CGFloat(Float.random(in: 0...1))))
        }
    }
    
    private func fakeEntryView(widthRatio: CGFloat) -> UIView {
        guard 0...1 ~= widthRatio else {
            fatalError()
        }
        
        let result = UIView()
        result.translatesAutoresizingMaskIntoConstraints = false
        result.backgroundColor = .systemGray6
        
        let width = UIScreen.main.bounds.size.width * widthRatio
        
        let constraint = result.widthAnchor.constraint(equalToConstant: width)
        constraint.isActive = true
        constraint.priority = .defaultHigh
        
        return result
    }
}

