//
//  DialogsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import RealmSwift

class DialogsVC: UITableViewController {
    
    // MARK: - Source data
    
    let settingPicture = SetPictureToTableCell()
    private let dialogsRequest = DialogsRequest()
    private let userRequest = UsersRequest()
    private var comleteDialogs = [Message]()
    private var dialogs = [Message]() {
        didSet {
            loadFromRealm()
            let notCompleteDialogs = comleteDialogs.filter { $0.firstName == "" }
            loadFromWeb(for: notCompleteDialogs)
        }
    }

    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dialogsRequest.makeRequest { [weak self] chats in
            self?.dialogs = chats
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChat",
            let cell = sender as? DialogsCell {
            let interlocutorID = self.tableView.indexPath(for: cell)?.row
            let messagesVC = segue.destination as! MessagesVC
            messagesVC.interlocutorID = comleteDialogs[interlocutorID!].userID
            messagesVC.title = comleteDialogs[interlocutorID!].firstName
            messagesVC.interlocutorName = comleteDialogs[interlocutorID!].firstName + " " + comleteDialogs[interlocutorID!].lastName
        }
    }
    
    // MARK: - TableView data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dialogs", for: indexPath) as! DialogsCell
        let dialog = comleteDialogs[indexPath.row]
        cell.configure(for: dialog)
        settingPicture.setPicture(url: dialog.photoURL, cacheLifeTime: .month, cell: cell, imageView: cell.imageView!, indexPath: indexPath, table: tableView)
        
        return cell
    }
    
    // MARK: - Loading names
    
    private func loadFromRealm() {
        guard let realm = try? Realm() else { return }
        comleteDialogs = dialogs.map {
            let user = realm.objects(User.self).filter("id == \($0.userID)")
            if let firstName = user.first?.firstName,
                let lastName = user.first?.lastName,
                let photoURL = user.first?.avatarURL {
                $0.firstName = firstName
                $0.lastName = lastName
                $0.photoURL = photoURL
            }
            return $0
        }
    }
    
    private func loadFromWeb(for arrayOfDialogs: [Message]) {
        userRequest.makeRequest(arrayOfDialogs: arrayOfDialogs) { [weak self] messages in
            self?.comleteDialogs.append(contentsOf: messages)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
}
