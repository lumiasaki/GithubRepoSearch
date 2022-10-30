//
//  Int+Extension.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/30.
//

import Foundation

extension Int {
        
    /// Convenience method to show shorter format of numeric count in 'xxx K', 'xxx M', 'xxx B'
    var formattedNumberString: String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""

        switch num {
        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)B"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)M"

        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: 1)
            return "\(sign)\(formatted)K"

        case 0...:
            return "\(self)"

        default:
            return "\(sign)\(self)"
        }
    }
}
