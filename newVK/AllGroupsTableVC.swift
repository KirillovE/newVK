//
//  AllGroupsTableVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 25.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class AllGroupsTableVC: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Source data
    
    struct Group: Equatable {
        static func ==(lhs: AllGroupsTableVC.Group, rhs: AllGroupsTableVC.Group) -> Bool {
            return lhs.name == rhs.name && lhs.imageName == rhs.imageName && lhs.subscriberCount == rhs.subscriberCount
        }
        
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
    
    var searchResult: [Group]?
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult?.count ?? allGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allGroups", for: indexPath)
        let chosenGroup = searchResult ?? allGroups
        
        let groupName = chosenGroup[indexPath.row].name
        let groupImageName = chosenGroup[indexPath.row].imageName
        let groupSubscriberCount = chosenGroup[indexPath.row].subscriberCount
        
        cell.textLabel?.text = groupName
        cell.imageView?.image = UIImage(named: groupImageName)
        cell.detailTextLabel?.text = "Подписчиков: " + String(groupSubscriberCount)
        
        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 4
        cell.imageView?.clipsToBounds = true

        return cell
    }
}

// MARK: - Extensions

extension AllGroupsTableVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchResult = nil
            self.tableView.reloadData()
            return
        }
        
        searchResult = allGroups.filter{$0.name.lowercased().contains(searchText.lowercased())}
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchResult = nil
        self.tableView.reloadData()
    }
}
