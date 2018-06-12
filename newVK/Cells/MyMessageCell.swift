//
//  MessageCell.swift
//  newVK
//
//  Created by Евгений Кириллов on 26.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class MyMessageCell: UITableViewCell {
    
    func configure(for message: Message) {
        textLabel?.text = message.body
        textLabel?.numberOfLines = 0
        
        detailTextLabel?.text = "Я"
        detailTextLabel?.textColor = UIColor.lightGray
    }

}
