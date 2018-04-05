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
//        loadPhoto(from: friend.avatarURL)
        
        textLabel?.text = firstName + " " + lastName
        detailTextLabel?.text = nick
        
        imageView?.layer.cornerRadius = frame.size.height / 2
        imageView?.clipsToBounds = true
    }
    
//    func loadPhoto(from urlString: String) {
//        let url = URL(string: urlString)
//        DispatchQueue.global().async {
//            guard let data = try? Data(contentsOf: url!) else { return }
//            DispatchQueue.main.async {
//                guard let image = UIImage(data: data) else { return }
//                self.imageView?.image = image
//            }
//        }
//    }

}
