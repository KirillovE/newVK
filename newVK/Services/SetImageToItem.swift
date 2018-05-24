//
//  SetImageToItem.swift
//  newVK
//
//  Created by Евгений Кириллов on 24.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class SetImageToItem: Operation {
    
    private let indexPath: IndexPath
    private weak var collectionView: UICollectionView?
    private var cell: UICollectionViewCell?
    private var imageView: UIImageView?
    
    init(cell: UICollectionViewCell, imageView: UIImageView, indexPath: IndexPath, collectionView: UICollectionView) {
        self.indexPath = indexPath
        self.collectionView = collectionView
        self.cell = cell
        self.imageView = imageView
    }
    
    override func main() {
        guard let collectionView = collectionView,
            let cell = cell,
            let imageView = imageView,
            let getCacheImage = dependencies[0] as? GetCacheImage,
            let image = getCacheImage.outputImage else {
                return
        }
        
        if let newIndexPath = collectionView.indexPath(for: cell),
            newIndexPath == indexPath {
            imageView.image = image
        } else {
            if collectionView.indexPath(for: cell) == nil {
                imageView.image = image
            }
        }
    }
    
}
