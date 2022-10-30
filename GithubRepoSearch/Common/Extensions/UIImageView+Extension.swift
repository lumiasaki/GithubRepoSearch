//
//  UIImageView+Extension.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/30.
//

import UIKit

extension UIImageView {
    
    /// Convenience method to load an image by given urlString
    /// - Parameter urlString: URLString
    func setImageUrl(_ urlString: String?) {
        guard let urlString = urlString else {
            return
        }
        
        Task {
            let (identifier, image) = await ImageLoader.downloadImage(with: urlString)
            
            guard let identifier = identifier, let image = image, identifier == urlString else {
                self.image = nil
                return
            }
            
            self.image = image
        }
    }
}
