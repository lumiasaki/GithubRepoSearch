//
//  String+Extension.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/31.
//

import Foundation

extension String {
    
    /// Localization
    /// - Returns: Localized string.
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
