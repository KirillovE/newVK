//
//  NewsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 25.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class NewsVC: UITableViewController {

    // MARK: - Source data
    
    var cellHeightsCache: [IndexPath: CGFloat] = [:]
    let defaultCellHeight: CGFloat = 20
    let newsRequest = NewsRequest()
    let requestFilter = "post"
    var news = [News]()
    let formatter = Formatting()
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        newsRequest.makeRequest(filter: self.requestFilter) { [weak self] news in
            self?.news = news
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        
        configureDate(forIndex: indexPath.row)
        setImageFromCache(cell: cell, indexPath: indexPath)
        cell.configure(for: news[indexPath.row])
        update(cell: cell, atIndex: indexPath, withHeight: cell.cellHeight)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeightsCache[indexPath] else {
            return defaultCellHeight
        }
        return height
    }
    
    // MARK: - Other methods
    
    func update(cell: NewsCell, atIndex index: IndexPath?, withHeight height: CGFloat?) {
        guard let index = index,
            let height = height,
            cell.bounds.height != height else { return }
        setNewHeight(height, atIndex: index)
    }
    
    func setNewHeight(_ height: CGFloat, atIndex index: IndexPath) {
        cellHeightsCache[index] = height
        tableView.beginUpdates()
        tableView.reloadRows(at: [index], with: .automatic)
        tableView.endUpdates()
    }

}

// MARK: - Extensions

extension NewsVC {
    
    func setImageFromCache(cell: NewsCell, indexPath: IndexPath) {
        let getAvatarImage = GetCacheImage(url: news[indexPath.row].photoURL, lifeTime: .month)
        let setAvatarToRow = SetImageToRow(cell: cell, imageView: cell.avatar, indexPath: indexPath, tableView: tableView)
        setAvatarToRow.addDependency(getAvatarImage)
        queue.addOperation(getAvatarImage)
        OperationQueue.main.addOperation(setAvatarToRow)
        
        let attachedImageURL = news[indexPath.row].attachedImageURL
        let getAttachedImage = GetCacheImage(url: attachedImageURL, lifeTime: .day)
        let setAttachedToRow = SetImageToRow(cell: cell, imageView: cell.attachedImage, indexPath: indexPath, tableView: tableView)
        setAttachedToRow.addDependency(getAttachedImage)
        queue.addOperation(getAttachedImage)
        OperationQueue.main.addOperation(setAttachedToRow)
    }
    
    func configureDate(forIndex index: Int) {
        news[index].day = formatter.formatDate(news[index].date, outputFormat: .day)
        news[index].time = formatter.formatDate(news[index].date, outputFormat: .time)
    }
    
}
