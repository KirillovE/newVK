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
    var interlocutorID: Int?
    let messagesRequest = MessagesRequest()
    var interlocutorName: String?
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell", for: indexPath) as! MyMessageCell
            cell.configure(for: message)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InterlocutorMessageCell", for: indexPath) as! InterlocutorMessageCell
            
            cell.configure(forMessage: message, with: interlocutorName!)
            return cell
        }
    }

 }
