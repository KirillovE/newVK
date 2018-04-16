//
//  MessagesVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 26.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class MessagesVC: UITableViewController {

    // MARK: - Demo data
    
    struct Message {
        let name, text: String
        let avatar: UIImage
    }
    
    let firstMessage = Message(name: "Дарт Вейдер",
                               text: "Если бы ты знал могущество тёмной стороны! \nОби-Ван не сказал, что случилось с твоим отцом?",
                               avatar: #imageLiteral(resourceName: "Вейдер"))
    let secondMessage = Message(name: "Люк Скайуокер",
                               text: "Он сказал достаточно",
                               avatar: #imageLiteral(resourceName: "Люк"))
    let thirdMessage = Message(name: "Люк Скайуокер",
                               text: "Он сказал, что это ты убил моего отца",
                               avatar: #imageLiteral(resourceName: "Люк"))
    let fourthMessage = Message(name: "Дарт Вейдер",
                                text: "Нет. Это я – твой отец",
                                avatar: #imageLiteral(resourceName: "Вейдер"))
    let fifthMessage = Message(name: "Люк Скайуокер",
                               text: "Нет. Нет. Это неправда. Это НЕВОЗМОЖНО!",
                               avatar: #imageLiteral(resourceName: "Люк"))
    var messages = [Message]()
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messages = [firstMessage, secondMessage, thirdMessage, fourthMessage, fifthMessage]
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell

        cell.configure(for: messages[indexPath.row])

        return cell
    }

 }
