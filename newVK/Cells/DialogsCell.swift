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
        textLabel?.text = String(dialog.userID)
        detailTextLabel?.text = dialog.body
    }

}
