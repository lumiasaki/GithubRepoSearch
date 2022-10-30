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
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}
