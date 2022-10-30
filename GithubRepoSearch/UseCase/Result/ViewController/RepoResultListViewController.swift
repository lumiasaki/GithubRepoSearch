//
//  RepoResultListViewController.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import UIKit
import Combine

final class RepoResultListViewController: UIViewController {
    
    private enum Section {
        
        case repositories
    }
    
    let viewModel: RepoResultListViewModel
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: ListLayout.defaultPlainListLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGroupedBackground
        view.delegate = self
        return view
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, RepositoryDisplayItem>! = nil
    
    private var bag: Set<AnyCancellable> = Set()
    
    init(viewModel: RepoResultListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElement()
        configureDataSource()
        bindViewModel()
    }
}

// MARK: - Private

extension RepoResultListViewController {
    
    private func setUpElement() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<RepositoryCell, RepositoryDisplayItem> { (cell, indexPath, repository) in
            return cell.configure(repository)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, RepositoryDisplayItem>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, repository: RepositoryDisplayItem) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: repository)
        }
    }
    
    private func bindViewModel() {
        viewModel
            .repositories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repositories in
                var snapshot = NSDiffableDataSourceSnapshot<Section, RepositoryDisplayItem>()
                snapshot.appendSections([.repositories])
                snapshot.appendItems(repositories)
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &bag)
    }
}

extension RepoResultListViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.keywordInput.send(searchController.searchBar.text)
    }
}

extension RepoResultListViewController: UICollectionViewDelegate {
    
    
}
