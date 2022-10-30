//
//  ListLayout.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/29.
//

import UIKit

enum ListLayout {
    
    /// Layout of repository list, just a plain list layout
    static var defaultPlainListLayout: UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}
