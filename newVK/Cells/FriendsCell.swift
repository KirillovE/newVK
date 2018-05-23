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
        detailTextLabel?.text = friend.isOnline ? "В сети" : "Не в сети"
        imageView?.image = #imageLiteral(resourceName: "заглушка")
        
        imageView?.layer.cornerRadius = frame.size.height / 2
        imageView?.clipsToBounds = true
        imageView?.backgroundColor = UIColor.white
    }
    
}
