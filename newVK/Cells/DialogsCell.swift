//
//  DialogsCell.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class DialogsCell: UITableViewCell {

    func configure(for dialog: Message) {
        textLabel?.text = dialog.firstName + " " + dialog.lastName
        detailTextLabel?.text = dialog.body
        imageView?.image = #imageLiteral(resourceName: "заглушка")
        
        imageView?.layer.cornerRadius = frame.height / 2
        imageView?.clipsToBounds = true
        imageView?.backgroundColor = UIColor.white
    }
    
}
