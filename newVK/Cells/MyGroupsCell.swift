//
//  MyGroupsCell.swift
//  newVK
//
//  Created by Евгений Кириллов on 15.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class MyGroupsCell: UITableViewCell {
    
    func configure(for group: Group) {
        textLabel?.text = group.name
        
        imageView?.layer.cornerRadius = frame.size.height / 4
        imageView?.clipsToBounds = true
        imageView?.backgroundColor = UIColor.white
    }
}
