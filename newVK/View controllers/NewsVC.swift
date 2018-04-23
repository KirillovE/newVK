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
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresher(_:)), for: .valueChanged)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        let currentNews = news[indexPath.row]
        cell.index = indexPath
        cell.heightDelegate = self
        
        configureDate(forIndex: indexPath.row)
        webImages.setImage(fromPath: currentNews.photoURL, to: cell.avatar)
        cell.attachedImage.image = nil
        webImages.setImage(fromPath: currentNews.attachedImageURL, to: cell.attachedImage)
        cell.configure(for: currentNews)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height = cellHeightsCache[indexPath] else {
            return defaultCellHeight
        }
        return height
    }
    
    // MARK: - Getting other news
    
    @IBAction func previousPressed(_ sender: UIBarButtonItem) {
        let userDefaults = UserDefaults.standard
        guard let startFrom = userDefaults.string(forKey: "start_from") else { return }
        newsRequest.makeRequest(filter: self.requestFilter, startFrom: startFrom) { [weak self] news in
            self?.news.append(contentsOf: news)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func refresher(_ control: UIRefreshControl) {
        newsRequest.makeRequest(filter: self.requestFilter) { [weak self] news in
            self?.news = news
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }

}

// MARK: - Extensions

extension NewsVC {
    
    func configureDate(forIndex index: Int) {
        news[index].day = formatter.formatDate(news[index].date, outputFormat: .day)
        news[index].time = formatter.formatDate(news[index].date, outputFormat: .time)
    }
    
}

extension NewsVC: CellHeightDelegate {
    
    func setHeight(_ height: CGFloat, to index: IndexPath) {
        cellHeightsCache[index] = height
        tableView.beginUpdates()
        tableView.reloadRows(at: [index], with: .automatic)
        tableView.endUpdates()
    }
    
}
