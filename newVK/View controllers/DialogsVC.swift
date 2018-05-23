//
//  DialogsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class DialogsVC: UITableViewController {
    
    private let dialogsRequest = DialogsRequest()
    private var dialogs = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        dialogsRequest.makeRequest { [weak self] chats in
            self?.dialogs = chats
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dialogs", for: indexPath)
        let dialog = dialogs[indexPath.row]
        cell.textLabel?.text = String(dialog.userID)
        cell.detailTextLabel?.text = dialog.body
        
        return cell
    }
    
}
