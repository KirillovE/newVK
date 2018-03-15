//
//  MyGroupsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 25.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift
import SwiftKeychainWrapper

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "myGroups", for: indexPath) as! MyGroupsCell
        cell.configure(for: groups[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groupToLeaveID = groups[indexPath.row].id
            leaveGroup(groupID: groupToLeaveID)
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}

// MARK: - Requesting groups from server

extension MyGroupsVC {
    
    func getGroups() {
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.string(forKey: "user_id")!
        let accessToken = KeychainWrapper.standard.string(forKey: "access_token")!
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
        
        saveMyGroups(groupsArray)
        return groupsArray
    }
}

// MARK: - Requesting server to leave selected group

extension MyGroupsVC {
    
    func leaveGroup(groupID: Int) {
        let userDefaults = UserDefaults.standard
        let accessToken = KeychainWrapper.standard.string(forKey: "access_token")!
        let apiVersion = userDefaults.double(forKey: "v")
        
        let parameters: Parameters = [/*"user_id": userID,*/
                                      "group_id": groupID,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        vkRequest.makeRequest(method: "groups.leave", parameters: parameters) { [weak self] json in
            self?.tableView.reloadData()
        }
    }
    
}

// MARK: - Saving data to Realm data base

extension MyGroupsVC {
    
    func saveMyGroups(_ groups: [Group]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(groups)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
}
