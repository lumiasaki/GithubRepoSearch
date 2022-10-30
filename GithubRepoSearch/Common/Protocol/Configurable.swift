//
//  Configurable.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import UIKit

/// Type which can be configured with a specific type of data
protocol Configurable {
    
    associatedtype DataType
    
    /// Configure by data
    /// - Parameter data: DataType
    func configure(_ data: DataType)
}

protocol ConfigurableCell: UICollectionViewCell, Configurable { }
