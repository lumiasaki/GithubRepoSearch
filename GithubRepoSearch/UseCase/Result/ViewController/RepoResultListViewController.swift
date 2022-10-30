//
//  RepoResultListViewController.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import UIKit
import Combine

final class RepoResultListViewController: UIViewController {
    
    private enum Section: Int {
        
        case repositories
        case footer
    }
    
    let viewModel: RepoResultListViewModel
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: ListLayout.defaultPlainListLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGroupedBackground
        view.delegate = self
        
        return view
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    
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
        let repositoryCellRegistration = UICollectionView.CellRegistration<RepositoryCell, RepositoryDisplayItem> { (cell, indexPath, repository) in
            return cell.configure(repository)
        }
        
        let footerCellRegistration = UICollectionView.CellRegistration<RepositoryListFooterCell, RepositoryListFooterCell.FooterType> { (cell, indexPath, footerType) in
            return cell.type = footerType
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, data: AnyHashable) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                return nil
            }
            
            switch section {
            case .repositories:
                if let repository = data as? RepositoryDisplayItem {
                    return collectionView.dequeueConfiguredReusableCell(using: repositoryCellRegistration, for: indexPath, item: repository)
                }
            case .footer:
                if let type = data as? RepositoryListFooterCell.FooterType {
                    return collectionView.dequeueConfiguredReusableCell(using: footerCellRegistration, for: indexPath, item: type)
                }
            }
            
            return nil
        }
    }
    
    private func bindViewModel() {
        viewModel
            .repositories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] repositoriesInfo in
                var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
                
                snapshot.appendSections([.repositories, .footer])
                
                snapshot.appendItems(repositoriesInfo.repositories, toSection: .repositories)
                
                snapshot.appendItems([repositoriesInfo.hasMore ? RepositoryListFooterCell.FooterType.loadMore : RepositoryListFooterCell.FooterType.noMore])
                
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &bag)
        
        viewModel
            .error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let error = error else {
                    return
                }
                let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alertController.addAction(cancelAction)
                
                self?.present(alertController, animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section), section == .footer else {
            return
        }
        
        // reach to the end of list
        viewModel.tryRequestNextPageIfNeeded()
    }
}
