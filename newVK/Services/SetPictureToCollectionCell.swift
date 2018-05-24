//
//  SetPictureToCollectionCell.swift
//  newVK
//
//  Created by Евгений Кириллов on 24.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class SetPictureToCollectionCell {
    
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    func setPicture(url: String, cacheLifeTime: ConvenientTimeInterval, cell: UICollectionViewCell, imageView: UIImageView, indexPath: IndexPath, collection: UICollectionView) {
        
        let getCacheImage = GetCacheImage(url: url, lifeTime: cacheLifeTime)
        let setImageToItem = SetImageToItem(cell: cell, imageView: imageView, indexPath: indexPath, collectionView: collection)
        setImageToItem.addDependency(getCacheImage)
        queue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToItem)
    }
    
}
