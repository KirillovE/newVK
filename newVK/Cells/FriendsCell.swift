//
//  FriedsCell.swift
//  newVK
//
//  Created by Евгений Кириллов on 15.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {
    
    func configure(for friend: User) {        
        textLabel?.text = friend.firstName + " " + friend.lastName
        imageView?.image = #imageLiteral(resourceName: "заглушка")
        if friend.isOnline {
            detailTextLabel?.text = "В сети"
            detailTextLabel?.textColor = .blue
        } else {
            detailTextLabel?.text = "Не в сети"
            detailTextLabel?.textColor = .lightGray
        }
        
        imageView?.layer.cornerRadius = frame.size.height / 2
        imageView?.clipsToBounds = true
        imageView?.backgroundColor = UIColor.white
    }
    
}
