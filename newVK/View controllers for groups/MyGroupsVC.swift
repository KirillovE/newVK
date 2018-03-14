//
//  MyGroupsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 25.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Alamofire
import SwiftyJSON

class MyGroupsVC: UITableViewController {
    
    // MARK: - Source data
    
    let vkRequest = VKRequestService()
    var groups = [Group]()
    var groupsJSON: JSON? {
        didSet {
            groups = appendGroups(from: groupsJSON)
            self.tableView.reloadData()
        }
    }
    
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
        let groupImage = groups[indexPath.row].photo

        cell.textLabel?.text = groupName
        cell.imageView?.image = groupImage
        
        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 4
        cell.imageView?.clipsToBounds = true

        return cell
    }

}

// MARK: - Requesting groups from server

extension MyGroupsVC {
    
    func getGroups() {
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.string(forKey: "user_id")!
        let accessToken = userDefaults.string(forKey: "access_token")!
        let apiVersion = userDefaults.double(forKey: "v")
        
        let parameters: Parameters = ["user_id": userID,
                                      "extended": 1,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        vkRequest.makeRequest(method: "groups.get", parameters: parameters) { [weak self] json in
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