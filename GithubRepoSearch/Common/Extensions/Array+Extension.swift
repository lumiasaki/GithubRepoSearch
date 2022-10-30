//
//  Array+Extension.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/30.
//

import Foundation

extension Array where Element: Hashable {
    
    /// Removing duplicates from array, following the naming convention
    /// - Returns: Duplicates removed array
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    /// Remove duplicates from self
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
