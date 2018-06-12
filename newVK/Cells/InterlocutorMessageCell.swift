//
//  InterlocutorMessageCell.swift
//  newVK
//
//  Created by Евгений Кириллов on 12.06.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class InterlocutorMessageCell: UITableViewCell {
    
    func configure(forMessage message: Message, with name: String) {
        textLabel?.text = message.body
        textLabel?.numberOfLines = 0
        
        detailTextLabel?.text = name
        detailTextLabel?.textColor = UIColor.lightGray
    }
    
}
