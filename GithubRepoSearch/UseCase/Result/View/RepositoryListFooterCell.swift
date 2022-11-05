//
//  RepositoryListFooterCell.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/30.
//

import UIKit

/// Showing loading or no more result on the end of list
final class RepositoryListFooterCell: UICollectionViewCell {
    
    enum FooterType {
        
        case noMore
        case loadMore
    }
    
    /// Set the type of cell, it controls the content of the footer cell
    var type: FooterType = .noMore {
        willSet {
            DispatchQueue.main.async {
                switch self.type {
                case .noMore:
                    self.contentLabel.isHidden = false
                    self.activityIndicator.isHidden = true
                case .loadMore:
                    self.contentLabel.isHidden = true
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                }
            }
        }
    }
    
    private lazy var contentLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .horizontal)
        view.numberOfLines = 2
        view.textAlignment = .center
        view.text = LocalizationConstant.Home.noMoreRepository.rawValue.localized()
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

extension RepositoryListFooterCell {
    
    private func setUp() {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        
        addSubview(container)
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        container.addArrangedSubview(contentLabel)
        container.addArrangedSubview(activityIndicator)
    }
}
