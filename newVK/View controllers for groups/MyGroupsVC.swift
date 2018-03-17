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
            appendGroups(from: groupsJSON)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - View Controller life cycle
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
    
    // MARK: - Navigation
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            let allGroupsVC = segue.source as! AllGroupsVC
            if let indexPath = allGroupsVC.tableView.indexPathForSelectedRow {
                let groupID = allGroupsVC.groups[indexPath.row].id
                joinGroup(groupID: groupID)
            }
        }
    }

}

// MARK: - Requesting groups from server

extension MyGroupsVC {
    
    func getGroups() {
        loadMyGroups()
        
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.string(forKey: "user_id")!
        let accessToken = KeychainWrapper.standard.string(forKey: "access_token")!
        let apiVersion = userDefaults.double(forKey: "v")
        
        let parameters: Parameters = ["user_id": userID,
                                      "extended": 1,
                                      "fields": "members_count",
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        vkRequest.makeRequest(method: "groups.get", parameters: parameters) { [weak self] json in
            self?.groupsJSON = json
        }
    }
    
    func appendGroups(from json: JSON?) {
        let itemsArray = json!["response", "items"]
        var groupsArray = [Group]()
        
        for (_, item) in itemsArray {
            let group = Group(json: item)
            groupsArray.append(group)
        }
        
        saveMyGroups(groupsArray)
        loadMyGroups()
    }
}

// MARK: - Requesting server to leave selected group

extension MyGroupsVC {
    
    func leaveGroup(groupID: Int) {
        let userDefaults = UserDefaults.standard
        let accessToken = KeychainWrapper.standard.string(forKey: "access_token")!
        let apiVersion = userDefaults.double(forKey: "v")
        
        let parameters: Parameters = ["group_id": groupID,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        vkRequest.makeRequest(method: "groups.leave", parameters: parameters) { [weak self] json in
            self?.tableView.reloadData()
        }
    }
    
}

// MARK: - Working with Realm data base

extension MyGroupsVC {
    
    /// сохранить группы в базу данных Realm
    func saveMyGroups(_ groups: [Group]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(groups, update: true)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    /// загрузить группы из базы данных Realm
    func loadMyGroups() {
        do {
            let realm = try Realm()
            let groups = realm.objects(Group.self)
            self.groups = Array(groups)
        } catch {
            print(error)
        }
    }
    
}

// MARK: - Requesting server to join selected group

extension MyGroupsVC {
    
    func joinGroup(groupID: Int) {
        let userDefaults = UserDefaults.standard
        let accessToken = KeychainWrapper.standard.string(forKey: "access_token")!
        let apiVersion = userDefaults.double(forKey: "v")
        
        let parameters: Parameters = ["group_id": groupID,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        vkRequest.makeRequest(method: "groups.join", parameters: parameters) { [weak self] json in
            self?.tableView.reloadData()
        }
    }
    
}
