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
    
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }

}

extension MessagesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        cell.textLabel?.text = "name"
        cell.detailTextLabel?.text = "text"
        cell.imageView?.image = #imageLiteral(resourceName: "картинка")
        return cell
    }
    
}
