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
    let webImages = ImagesFromWeb()
    
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
        let currentNews = news[indexPath.row]
        
        configureDate(forIndex: indexPath.row)
        cell.configure(for: currentNews)
        webImages.setImage(fromPath: currentNews.photoURL, to: cell.avatar)
        webImages.setImage(fromPath: currentNews.attachedImageURL, to: cell.attachedImage)
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
    
    func configureDate(forIndex index: Int) {
        news[index].day = formatter.formatDate(news[index].date, outputFormat: .day)
        news[index].time = formatter.formatDate(news[index].date, outputFormat: .time)
    }
    
}
