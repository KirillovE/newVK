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
    @IBOutlet weak var messageText: UILabel!
    
    func configure(for message: Message) {
        messageText?.text = message.body
        avatar?.layer.cornerRadius = avatar.frame.size.height / 2
    }

}
