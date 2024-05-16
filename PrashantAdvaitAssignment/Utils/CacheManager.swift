//
//  CacheManager.swift
//  PrashantAdvaitAssignment
//
//  Created by Raman choudhary on 10/05/24.
//

import UIKit

class CacheManager {
    static let shared = CacheManager()  // Singleton instance
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    private let memoryCache = NSCache<NSString, UIImage>()
    private var tasks = [String: URLSessionDataTask]()
    
    init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache")
        createCacheDirectory()
    }
    
    private func createCacheDirectory() {
        do {
            try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating cache directory: \(error)")
        }
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        let keyNSString = NSString(string: key)
        memoryCache.setObject(image, forKey: keyNSString)
        
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: fileURL)
        }
    }
    
    func image(forKey key: String) -> UIImage? {
        let keyNSString = NSString(string: key)
        
        // Try to fetch the image from memory cache
        if let image = memoryCache.object(forKey: keyNSString) {
            return image
        }
        
        // Fetch from disk cache
        let fileURL = cacheDirectory.appendingPathComponent(key)
        guard let imageData = try? Data(contentsOf: fileURL),
              let image = UIImage(data: imageData) else {
            return nil
        }
        
        // Add the image to memory cache for future accesses
        memoryCache.setObject(image, forKey: keyNSString)
        return image
    }
    
    func cancelImageLoad(forKey key: String) {
        tasks[key]?.cancel()
        tasks[key] = nil
    }
    
    func fetchImage(from url: URL,key:String, completion: @escaping (UIImage?,Error?) -> Void) {
        
        // Check cache first
        if let cachedImage = image(forKey: key) {
            completion(cachedImage, nil)
            return
        }
        
        // Cancel existing task if there's one
        cancelImageLoad(forKey: key)
        
        // Download image if not in cache
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil, NSError(domain: "com.yourapp.error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to load image"]))
                }
                return
            }
            
            // Cache the image
            self.setImage(image, forKey: key)
            self.tasks[key] = nil
            
            DispatchQueue.main.async {
                completion(image, nil)
            }
        }
        tasks[key] = task
        task.resume()
    }
}
