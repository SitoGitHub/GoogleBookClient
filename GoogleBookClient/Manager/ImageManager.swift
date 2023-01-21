//
//  ImageManager.swift
//  GoogleBookClient
//
//  Created by Aleksei Grachev on 21/1/23.
//

import UIKit
// MARK: - ImageManagerProtocol
protocol ImageManagerProtocol {
    func loadImageUsingUrlString(urlString: String) -> UIImage?
}
// MARK: - class ImageManager
final class ImageManager {
    // MARK: -
    let imageCache = NSCache<AnyObject, AnyObject>()
    var image: UIImage?
    var imageUrlString: String?
}
// MARK: - extension ImageManager: ImageManagerProtocol
extension ImageManager: ImageManagerProtocol {
    // load Image Using Url String
    func loadImageUsingUrlString(urlString: String) -> UIImage? {
        imageUrlString = urlString
        
        if let imageForCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            image = imageForCache
            return image
        }
        guard let url = URL(string: urlString) else {
            if let image = UIImage(named: "noThumb") {
                self.image = image
            }
            return image
        }
        let data = try? Data(contentsOf: url)
        guard let data = data, let imageToCache = UIImage(data: data) else {
            if let image = UIImage(named: "noThumb") {
                self.image = image
            }
            return image
        }
        if imageUrlString == urlString {
            image = imageToCache
        }
        self.imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
        return image
    }
}
