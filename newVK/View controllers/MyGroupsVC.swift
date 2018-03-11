//
//  MyGroupsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 25.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyGroupsVC: UITableViewController {
    
// MARK: - Source data
    
    var settings: SettingsStorage!
    let vkRequest = VKRequestService()
    var groups = [Group]()
    var groupsJSON: JSON? {
        didSet {
            groups = appendGroups(from: groupsJSON)
            self.tableView.reloadData()
        }
    }

    var myGroups: [AllGroupsVC.Group] =
        [AllGroupsVC.Group(name: "ГикБрейнс", imageName: "группа.гикбрейнс", subscriberCount: 10),
         AllGroupsVC.Group(name: "Swift", imageName: "группа.свифт", subscriberCount: 77)
        ]
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroups()
    }

// MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myGroups", for: indexPath)
        let groupName = groups[indexPath.row].name
//        let groupImageName = myGroups[indexPath.row].imageName
        
        cell.textLabel?.text = groupName
//        cell.imageView?.image = UIImage(named: groupImageName)
        
//        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 4
//        cell.imageView?.clipsToBounds = true

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

extension MyGroupsVC {

    // MARK: - Adding a group
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        guard segue.identifier == "addGroupSegue" else { return }
        let allGroupsVC = segue.source as! AllGroupsVC
        addNewGroup(from: allGroupsVC)
    }
    
    func addNewGroup(from tableVC: AllGroupsVC) {
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
    
    // MARK: - Requesting groups from server
    
    func getGroups() {
        let parameters: Parameters = ["user_id": settings.userID,
                                      "extended": 1,
                                      "access_token": settings.accessToken,
                                      "v": settings.apiVersion
        ]
        
        vkRequest.makeRequest(method: "groups.get", parameters: parameters) { [weak self] json in
            self?.groupsJSON = json
        }
    }
    
    func getSearchedGroups(groupToFind q: String, numberOfResults: Int) {
        let parameters: Parameters = ["q": q,
                                      "type": "group",
                                      "count": numberOfResults,
                                      "access_token": settings.accessToken,
                                      "v": settings.apiVersion
        ]
        
        vkRequest.makeRequest(method: "groups.search", parameters: parameters) { [weak self] json in
            self?.groupsJSON = json
        }
    }
    
    func appendGroups(from json: JSON?) -> [Group] {
        let itemsArray = json!["response", "items"]
        var groupsArray = [Group]()
        
        for (_, item) in itemsArray {
            let group = Group(json: item)
            groupsArray.append(group)
        }
        
        return groupsArray
    }
    
}


