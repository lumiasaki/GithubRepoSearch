//
//  ImageLoader.swift
//  GithubRepoSearch
//
//  Created by tianren.zhu on 2022/10/30.
//

import UIKit

/// Simple image loader to drive setUrl function in UIImageView
final class ImageLoader {
    
    /// cache downloaded images
    private static let cache: NSCache<NSString, UIImage> = NSCache()
}

// MARK: - Public

extension ImageLoader {
    
    @MainActor
    static func downloadImage(with urlString: String) async -> (urlString: String?, image: UIImage?) {
        guard let url = URL(string: urlString) else {
            return (nil, nil)
        }
        
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            return (urlString, cachedImage)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else {
                return (nil, nil)
            }
                                    
            cache.setObject(image, forKey: urlString as NSString)
            
            return (urlString, image)
        } catch {
            return (nil, nil)
        }
    }
}
