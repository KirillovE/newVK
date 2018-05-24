//
//  SetImageToRow.swift
//  newVK
//
//  Created by Евгений Кириллов on 05.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class SetImageToRow: Operation {
    
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: UITableViewCell?
    private var imageView: UIImageView?
    
    init(cell: UITableViewCell, imageView: UIImageView, indexPath: IndexPath, tableView: UITableView) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
        self.imageView = imageView
    }
    
    override func main() {
        guard let tableView = tableView,
            let cell = cell,
            let imageView = imageView,
            let getCacheImage = dependencies[0] as? GetCacheImage,
            let image = getCacheImage.outputImage else {
                return
        }
        
        if let newIndexPath = tableView.indexPath(for: cell),
            newIndexPath == indexPath {
            imageView.image = image
        } else {
            if tableView.indexPath(for: cell) == nil {
                imageView.image = image
            }
        }
    }
    
}
