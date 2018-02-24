//
//  FriendsTableVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class FriendsTableVC: UITableViewController {

    struct Friend {
        let name: String
        let imageName: String
    }
    
    let friendsList: [Friend] = [Friend(name: "Адриана Лима", imageName: "друг.Адриана"),
                                 Friend(name: "Алессандра Амбросио", imageName: "друг.Алессандра"),
                                 Friend(name: "Дэвид Бекхэм", imageName: "друг.Бекхэм"),
                                 Friend(name: "В", imageName: "друг.В"),
                                 Friend(name: "Леонардо Ди Каприо", imageName: "друг.Ди Каприо"),
                                 Friend(name: "Павел Дуров", imageName: "друг.Дуров"),
                                 Friend(name: "Илон Маск", imageName: "друг.Маск"),
                                 Friend(name: "Меган Фокс", imageName: "друг.Меган"),
                                 Friend(name: "Нео", imageName: "друг.Нео"),
                                 Friend(name: "Криштиану Роналду", imageName: "друг.Роналду"),
                                 Friend(name: "Роузи Хантингтон-Уайтли", imageName: "друг.Роузи"),
                                 Friend(name: "Энакин Скайуокер", imageName: "друг.Энакин")
    ]
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friendsList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friends", for: indexPath)
        
        let friendName = friendsList[indexPath.row].name
        let friendImage = friendsList[indexPath.row].imageName
        
        cell.textLabel?.text = friendName
        cell.imageView?.image = UIImage.init(named: friendImage)
        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 2
        cell.imageView?.clipsToBounds = true
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFriendImage" {
            let cell = sender as! UITableViewCell
            let imageIndex = self.tableView.indexPath(for: cell)?.row
            let collectionVC = segue.destination as! FriendCollectionVC
            collectionVC.imageName = friendsList[imageIndex!].imageName
            collectionVC.title = friendsList[imageIndex!].name
        }
    }
}
