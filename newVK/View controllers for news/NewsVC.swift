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
    
    let newsRequest = NewsRequest()
    let requestFilter = "post"
    var news = [News]()
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    let dateFormatterForDay: DateFormatter = {
        let fmtr = DateFormatter()
        fmtr.dateFormat = "dd.MM.yyyy"
        return fmtr
    }()
    
    let dateFormatterForTime: DateFormatter = {
        let fmtr = DateFormatter()
        fmtr.dateFormat = "HH.mm"
        return fmtr
    }()
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            self.newsRequest.makeRequest(filter: self.requestFilter) { [weak self] news in
                self?.news = news
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        
        formatDate(forNews: &news[indexPath.row])
        setImageFromCache(cell: cell, indexPath: indexPath)
        cell.configure(for: news[indexPath.row])
        
        return cell
    }
    
    // MARK: -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showExtendedNews" {
            let cell = sender as! NewsCell
            let newsIndex = self.tableView.indexPath(for: cell)?.row
            let newsVC = segue.destination as! ExtendedNewsVC
            newsVC.news = self.news[newsIndex!]
            newsVC.imageForAvatar = cell.avatar.image
            newsVC.imageToShow = cell.attachedImage.image
        }
    }

}

// MARK: - Extensions

extension NewsVC {
    
    func formatDate(forNews news: inout News) {
        let numberDate = Date(timeIntervalSince1970: news.date)
        news.day = dateFormatterForDay.string(from: numberDate)
        news.time = dateFormatterForTime.string(from: numberDate)
    }
    
}

extension NewsVC {
    
    func setImageFromCache(cell: NewsCell, indexPath: IndexPath) {
        let getCacheImage = GetCacheImage(url: news[indexPath.row].photoURL)
        let setImageToRow = SetImageToRow(cell: cell, imageView: cell.avatar, indexPath: indexPath, tableView: tableView)
        setImageToRow.addDependency(getCacheImage)
        queue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)
    }
    
}
