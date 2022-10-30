//
//  UIView+Extension.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/30.
//

import UIKit

extension UIView {
    
    /// Convenience method to create a spacer to be used in UIStackView
    /// - Parameter axis: Axis
    /// - Returns: Spacer view
    static func stackViewSpacer(_ axis: NSLayoutConstraint.Axis) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: axis)
        return view
    }
}

