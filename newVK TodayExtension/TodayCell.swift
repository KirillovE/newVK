//
//  TodayCell.swift
//  newVK TodayExtension
//
//  Created by Евгений Кириллов on 28.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class TodayCell: UITableViewCell {

    func configure(withNews news: News) {
        textLabel?.text = news.name
        detailTextLabel?.text = news.text
        detailTextLabel?.numberOfLines = 1
        if news.photoURL == "" {
            imageView?.image = #imageLiteral(resourceName: "новости")
        } else {
            imageView?.image = #imageLiteral(resourceName: "картинка")
        }
    }

}
