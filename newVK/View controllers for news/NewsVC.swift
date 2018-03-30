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
    var news = [News]()
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsRequest.makeRequest() { [weak self] news in
            self?.news = news
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        cell.configure(for: news[indexPath.row])
        return cell
    }

}
