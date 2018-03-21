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
    
    let groupsRequest = GroupsRequest()
    var groups: Results<Group>!
    var token: NotificationToken?
    
    // MARK: - View Controller life cycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        pairTableAndRealm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        groupsRequest.makeRequest()
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
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let groupToLeaveID = groups[indexPath.row].id
//            leaveGroup(groupID: groupToLeaveID)
//            groups.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
    
    // MARK: - Navigation
    
//    @IBAction func addGroup(segue: UIStoryboardSegue) {
//        if segue.identifier == "addGroup" {
//            let allGroupsVC = segue.source as! AllGroupsVC
//            if let indexPath = allGroupsVC.tableView.indexPathForSelectedRow {
//                let groupID = allGroupsVC.groups[indexPath.row].id
//                joinGroup(groupID: groupID)
//            }
//        }
//    }

}

// MARK: - Extensions

extension MyGroupsVC {
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        groups = realm.objects(Group.self)
        token = groups.observe { [weak self] changes in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_,  let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map(    { IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.deleteRows(at: deletions.map(     { IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map( { IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

//extension MyGroupsVC {
//
//    func leaveGroup(groupID: Int) {
//        let userDefaults = UserDefaults.standard
//        let accessToken = KeychainWrapper.standard.string(forKey: "access_token")!
//        let apiVersion = userDefaults.double(forKey: "v")
//
//        let parameters: Parameters = ["group_id": groupID,
//                                      "access_token": accessToken,
//                                      "v": apiVersion
//        ]
//
//        vkRequest.makeRequest(method: "groups.leave", parameters: parameters) { [weak self] json in
//            self?.tableView.reloadData()
//        }
//    }
//
//}

//extension MyGroupsVC {
//
//    func joinGroup(groupID: Int) {
//        let userDefaults = UserDefaults.standard
//        let accessToken = KeychainWrapper.standard.string(forKey: "access_token")!
//        let apiVersion = userDefaults.double(forKey: "v")
//
//        let parameters: Parameters = ["group_id": groupID,
//                                      "access_token": accessToken,
//                                      "v": apiVersion
//        ]
//
//        vkRequest.makeRequest(method: "groups.join", parameters: parameters) { [weak self] json in
//            self?.tableView.reloadData()
//        }
//    }
//
//}

