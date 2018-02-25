//
//  AllGroupsTableVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 25.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class AllGroupsTableVC: UITableViewController {
    
    // MARK: - Source data
    
    struct Group {
        let name, imageName: String
        let subscriberCount: Int
    }
    
    var allGroups: [Group] = [Group(name: "ГикБрейнс", imageName: "группа.гикбрейнс", subscriberCount: 10),
                             Group(name: "Кино", imageName: "группа.кино", subscriberCount: 20),
                             Group(name: "НЛО", imageName: "группа.нло", subscriberCount: 1),
                             Group(name: "Swift", imageName: "группа.свифт", subscriberCount: 77),
                             Group(name: "Тёмная сторона", imageName: "группа.тёмная сторона", subscriberCount: 2),
                             Group(name: "Tesla", imageName: "группа.тесла", subscriberCount: 300),
                             Group(name: "Формула-1", imageName: "группа.формула 1", subscriberCount: 100),
                             Group(name: "Формула-E", imageName: "группа.формула е", subscriberCount: 50),
                             Group(name: "Apple", imageName: "группа.эпл", subscriberCount: 700),
                             Group(name: "Linux", imageName: "группа.Linux", subscriberCount: 15),
                             Group(name: "Objective-C", imageName: "группа.Oblective C", subscriberCount: 2),
                             Group(name: "Windows", imageName: "группа.Windows", subscriberCount: 99)
    ]
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allGroups", for: indexPath)

        let groupName = allGroups[indexPath.row].name
        let groupImageName = allGroups[indexPath.row].imageName
        let groupSubscriberCount = allGroups[indexPath.row].subscriberCount
        
        cell.textLabel?.text = groupName
        cell.imageView?.image = UIImage(named: groupImageName)
        cell.detailTextLabel?.text = String(groupSubscriberCount)
        
        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 4
        cell.imageView?.clipsToBounds = true

        return cell
    }

}
