//
//  SetPictureToTableCell.swift
//  newVK
//
//  Created by Евгений Кириллов on 24.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class SetPictureToTableCell {
    
    private let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    func setPicture(url: String, cacheLifeTime: ConvenientTimeInterval, cell: UITableViewCell, imageView: UIImageView, indexPath: IndexPath, table: UITableView) {
        
        let getCacheImage = GetCacheImage(url: url, lifeTime: cacheLifeTime)
        let setImageToRow = SetImageToRow(cell: cell, imageView: imageView, indexPath: indexPath, tableView: table)
        setImageToRow.addDependency(getCacheImage)
        queue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)
    }
    
}
