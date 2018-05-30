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
    var newsArray = [News]()
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        newsRequest.makeRequest(resultsCount: 10) { [weak self] news in
            self?.newsArray = news
            self?.newsTableView.reloadData()
        }
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
        layout.trailingCaption = specificNews.day + " " + specificNews.time
        layout.subcaption = specificNews.text
        layout.image = #imageLiteral(resourceName: "картинка")
        let message = MSMessage()
        message.layout = layout
        activeConversation?.insert(message)
    }
    
}
