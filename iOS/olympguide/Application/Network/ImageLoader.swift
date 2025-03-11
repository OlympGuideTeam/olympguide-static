//
//  ImageLoader.swift
//  olympguide
//
//  Created by Tom Tim on 21.02.2025.
//

import Foundation
import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private var cache: [String: UIImage] = [:]

    private init() {}

    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache[urlString] {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                let self = self,
                let data = data,
                error == nil,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self.cache[urlString] = image
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
