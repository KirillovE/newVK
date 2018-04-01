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
        loadPhoto(from: group.photoURL)
        let membersCount = group.membersCount
        
        textLabel?.text = groupName
        detailTextLabel?.text = "Подписчиков: " + formatInt(membersCount)
        
        imageView?.layer.cornerRadius = frame.size.height / 4
        imageView?.clipsToBounds = true
    }
    
    func formatInt(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        let niceNumber = formatter.string(from: NSNumber(integerLiteral: number))
        
        if let niceString = niceNumber {
            return niceString
        } else {
            return "нет данных"
        }
    }
    
    func loadPhoto(from urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url!) else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                self.imageView?.image = image
            }
        }
    }

}
