//
//  DialogsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class DialogsVC: UITableViewController {
    
    private let webImages = ImagesFromWeb()
    private let dialogsRequest = DialogsRequest()
    private let userRequest = UsersRequest()
    private var comleteDialogs = [Message]()
    private var dialogs = [Message]() {
        didSet {
            userRequest.makeRequest(arrayOfDialogs: dialogs) { [weak self] messages in
                self?.comleteDialogs = messages
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dialogsRequest.makeRequest { [weak self] chats in
            self?.dialogs = chats
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dialogs", for: indexPath) as! DialogsCell
        let dialog = comleteDialogs[indexPath.row]
        cell.configure(for: dialog)
        webImages.setImage(fromPath: dialog.photoURL, to: cell.imageView!)
        
        return cell
    }
    
}
