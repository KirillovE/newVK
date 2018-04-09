//
//  MessageCell.swift
//  newVK
//
//  Created by Евгений Кириллов on 26.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var messageText: UILabel!
    
    func configure(for message: MessagesVC.Message) {
        name?.text = message.name
        messageText?.text = message.text
        avatar?.image = message.avatar
        
        avatar?.layer.cornerRadius = avatar.frame.size.height / 2
    }

}
