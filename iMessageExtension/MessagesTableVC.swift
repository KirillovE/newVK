//
//  MessagesTableVC.swift
//  iMessageExtension
//
//  Created by Евгений Кириллов on 30.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit
import Messages

class MessagesTableVC: UITableViewController {
    
    // MARK: - Source data
    
    let newsArray = [News]()

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "iMessageCell", for: indexPath) as! MessagesCell
        let specificNews = newsArray[indexPath.row]
        cell.configure(forNews: specificNews)

        return cell
    }

}
