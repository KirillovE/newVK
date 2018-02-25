//
//  MyGroupsTableVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 25.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class MyGroupsTableVC: UITableViewController {
    
    // MARK: - Source data

    var myGroups: [AllGroupsTableVC.Group] =
        [AllGroupsTableVC.Group(name: "ГикБрейнс", imageName: "группа.гикбрейнс", subscriberCount: 10),
         AllGroupsTableVC.Group(name: "Swift", imageName: "группа.свифт", subscriberCount: 77)
        ]

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myGroups", for: indexPath)
        let groupName = myGroups[indexPath.row].name
        let groupImageName = myGroups[indexPath.row].imageName
        
        cell.textLabel?.text = groupName
        cell.imageView?.image = UIImage(named: groupImageName)
        
        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 4
        cell.imageView?.clipsToBounds = true

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - Extensions

extension MyGroupsTableVC {

    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroupSegue" {
            let allGroupsVC = segue.source as! AllGroupsTableVC
            addGroup(from: allGroupsVC)
        }
    }
    
    func addGroup(from tableVC: AllGroupsTableVC) {
        if let indexPath = tableVC.tableView.indexPathForSelectedRow {
            let groupFound = tableVC.searchResult?[indexPath.row]
            let groupPicked = tableVC.allGroups[indexPath.row]
            let group = groupFound ?? groupPicked
            
            if !myGroups.contains(group) {
                myGroups.append(group)
                tableView.reloadData()
            }
        }
    }
    
}


