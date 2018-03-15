//
//  AllGroupsCell.swift
//  newVK
//
//  Created by Евгений Кириллов on 15.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class AllGroupsCell: UITableViewCell {
    func configure(for group: Group) {
        let groupName = group.name
        let groupImage = group.photo
        let membersCount = group.membersCount
        
        textLabel?.text = groupName
        imageView?.image = groupImage
        detailTextLabel?.text = "Подписчиков: " + String(membersCount)
        
        imageView?.layer.cornerRadius = frame.size.height / 4
        imageView?.clipsToBounds = true
    }
}
