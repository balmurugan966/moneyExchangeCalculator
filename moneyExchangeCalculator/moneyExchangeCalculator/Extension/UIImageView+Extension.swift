//
//  UIImageView+Extension.swift
//  moneyExchangeCalculator
//
//  Created by balamuruganc on 22/12/24.
//

import UIKit

// Cache for storing downloaded images
private var imageCache = NSCache<NSString, UIImage>()

// Extension for UIImageView to handle image download and caching
extension UIImageView {
    func loadImage(from urlString: String) {
        // Check if image is already cached
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        // Otherwise, download the image asynchronously
        guard let url = URL(string: urlString) else { return }
        
        // Use a background queue with appropriate QoS for image downloading
        DispatchQueue.global(qos: .background).async {
            do {
                // Download the image data
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else { return }
                
                // Cache the image for future use
                imageCache.setObject(image, forKey: urlString as NSString)
                
                // Update the UIImageView on the main thread
                DispatchQueue.main.async {
                    self.image = image
                }
            } catch {
                print("Failed to load image from URL: \(error.localizedDescription)")
            }
        }
    }
}


