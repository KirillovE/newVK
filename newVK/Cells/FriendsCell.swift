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
        
        let firstName = friend.firstName
        let lastName = friend.lastName
        let nick = friend.nick
        
        textLabel?.text = firstName + " " + lastName
        detailTextLabel?.text = nick
        
        imageView?.layer.cornerRadius = frame.size.height / 2
        imageView?.clipsToBounds = true
        imageView?.backgroundColor = UIColor.white
    }
    
}
