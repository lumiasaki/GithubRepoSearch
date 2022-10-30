//
//  LoadingView.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/31.
//

import UIKit

/// Simple loading view with an indicator at center
final class LoadingView: UIView {
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
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

extension LoadingView {
    
    private func setUp() {
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        loadingIndicator.startAnimating()
    }
}
