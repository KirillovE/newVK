//
//  MessagesViewController.swift
//  iMessageExtension
//
//  Created by Евгений Кириллов on 30.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    // MARK: - Source data
    
    @IBOutlet weak var newsTableView: UITableView!
    let newsRequest = NewsRequest()
    let userDefaults = UserDefaults(suiteName: "group.newVK")
    var newsArray = [News]()
    let newsCount = 10
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        newsRequest.makeRequest(resultsCount: newsCount) { [weak self] news in
            self?.newsArray = news
            self?.newsTableView.reloadData()
        }
        
        newsTableView.refreshControl = UIRefreshControl()
        newsTableView.refreshControl?.addTarget(self, action: #selector(refresher(_:)), for: .valueChanged)
    }

}

// MARK: - Table view data source

extension MessagesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        configure(cell: cell, withNews: newsArray[indexPath.row])
        return cell
    }
    
    func configure(cell: UITableViewCell, withNews news: News) {
        cell.textLabel?.text = news.name
        
        cell.detailTextLabel?.numberOfLines = 3
        if news.text != "" {
            cell.detailTextLabel?.text = news.text
            cell.detailTextLabel?.textColor = .black
        } else {
            cell.detailTextLabel?.text = "только вложение"
            cell.detailTextLabel?.textColor = .lightGray
        }
        
        if news.photoURL == "" {
            cell.imageView?.image = #imageLiteral(resourceName: "новости")
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "картинка")
        }
    }
    
}

// MARK: - Table view delegate

extension MessagesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let layout = MSMessageTemplateLayout()
        let specificNews = newsArray[indexPath.row]
        layout.caption = specificNews.name
        layout.subcaption = specificNews.text
        layout.image = #imageLiteral(resourceName: "картинка")
        layout.imageTitle = specificNews.day
        layout.imageSubtitle = specificNews.time
        let message = MSMessage()
        message.layout = layout
        activeConversation?.insert(message)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let newsBeforeLoadingPrevious = newsArray.count - 2
        if indexPath.row == newsBeforeLoadingPrevious {
            guard let startFrom = userDefaults?.string(forKey: "start_from") else { return }
            newsRequest.makeRequest(resultsCount: newsCount, startFrom: startFrom) { [weak self] news in
                self?.newsArray.append(contentsOf: news)
                DispatchQueue.main.async {
                    self?.newsTableView.reloadData()
                }
            }
        }
    }
    
}

extension MessagesViewController {
    
    @objc func refresher(_ control: UIRefreshControl) {
        newsRequest.makeRequest(resultsCount: 10) { [weak self] news in
            self?.newsArray = news
            DispatchQueue.main.async {
                self?.newsTableView.refreshControl?.endRefreshing()
                self?.newsTableView.reloadData()
            }
        }
    }
    
}
