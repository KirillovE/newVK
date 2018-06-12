//
//  MessagesVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 26.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class MessagesVC: UITableViewController {

    // MARK: - Source data
    
    var messages = [Message]()
    var interlocutorAvatar: UIImage?
    var interlocutorID: Int?
    let messagesRequest = MessagesRequest()
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = interlocutorID else { return }
        messagesRequest.makeRequest(dialogWith: id) { [weak self] dialog in
            self?.messages = dialog
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.out {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MessageCell
            cell.configure(for: message)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InterlocutorMessageCell", for: indexPath) as! MessageCell
            cell.avatar.image = interlocutorAvatar
            cell.configure(for: message)
            return cell
        }
    }

 }
