//
//  GetCacheImage.swift
//  newVK
//
//  Created by Евгений Кириллов on 05.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

enum ConvenientTimeInterval: TimeInterval {
    case minute = 60
    case hour = 3_600
    case day = 86_400
    case week = 604_800
    case month = 2_592_000
}

class GetCacheImage: Operation {
    
    private let cacheLifeTime: ConvenientTimeInterval
    private static let pathName: String = {
        let pathName = "images"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return pathName
        }
        
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private let url: String
    var outputImage: UIImage?
    
    private lazy var filePath: String? = {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        let hashName = String(describing: url.hashValue)
        
        return cachesDirectory.appendingPathComponent(GetCacheImage.pathName + "/" + hashName).path
    }()
    
    init(url: String, lifeTime: ConvenientTimeInterval) {
        self.url = url
        self.cacheLifeTime = lifeTime
    }
    
    override func main() {
        guard filePath != nil && !isCancelled else { return }
        
        if getImageFromCache() { return }
        guard !isCancelled else { return }
        
        if !downloadImage() { return }
        guard !isCancelled else { return }
        
        saveImageToCache()
    }
    
    private func getImageFromCache() -> Bool {
        guard let fileName = filePath,
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date else {
                return false
        }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime.rawValue,
            let image = UIImage(contentsOfFile: fileName) else {
                return false
        }
        
        outputImage = image
        return true
    }
    
    private func downloadImage() -> Bool {
        guard let url = URL(string: url),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) else {
            return false
        }
        
        outputImage = image
        return true
    }
    
    private func saveImageToCache() {
        guard let fileName = filePath,
            let image = outputImage else {
                return
        }
        
        let data = UIImagePNGRepresentation(image)
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
}
