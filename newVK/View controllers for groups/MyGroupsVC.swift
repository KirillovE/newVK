//
//  MyGroupsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 25.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import RealmSwift
import FirebaseDatabase
import SwiftyJSON

class MyGroupsVC: UITableViewController {
    
    // MARK: - Source data
    
    let groupsRequest = GroupsRequest()
    var groups: Results<Group>!
    var token: NotificationToken?
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    // MARK: - View controller life cycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.groupsRequest.getGroups()
        pairTableAndRealm()
    }
    
    deinit {
        token?.invalidate()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myGroups", for: indexPath) as! MyGroupsCell
        cell.configure(for: groups[indexPath.row])
        
        let getCacheImage = GetCacheImage(url: groups[indexPath.row].photoURL, lifeTime: .month)
        let setImageToRow = SetImageToRow(cell: cell, imageView: cell.imageView!, indexPath: indexPath, tableView: tableView)
        setImageToRow.addDependency(getCacheImage)
        queue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let groupToLeave = groups[indexPath.row]
        if editingStyle == .delete {
            groupsRequest.leaveGroup(groupID: groupToLeave.id)
            do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(groupToLeave)
                }
            } catch {
                print(error)
            }
        }
    }

    
    // MARK: - Navigation
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            let allGroupsVC = segue.source as! AllGroupsVC
            if let indexPath = allGroupsVC.tableView.indexPathForSelectedRow {
                let groupToJoin = allGroupsVC.groups[indexPath.row]
                
                groupsRequest.joinGroup(groupID: groupToJoin.id)
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(groupToJoin, update: true)
                    }
                } catch {
                    print(error)
                }
                
                addGroupToFirebase(groupToJoin)
            }
        }
    }
    
    func addGroupToFirebase(_ group: Group) {
        let groupID = String(group.id)
        let userDefaults = UserDefaults.standard
        let numberOfUser = userDefaults.integer(forKey: "numberOfUserInFireBase")
        let ref = Database.database().reference()
    
        ref.child("Users/\(numberOfUser)/Groups").observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                ref.child("Users/\(numberOfUser)/Groups").setValue([groupID])
            } else {
                let json = JSON(snapshot.value as Any)
                let groupsArray = json.arrayValue
                for (index, group) in groupsArray.enumerated() {
                    if groupID == group.stringValue {
                        print("номер совпавшего элемента \(index)")
                        return
                    }
                }
                let newIndex = String(groupsArray.count)
                ref.child("Users/\(numberOfUser)/Groups").updateChildValues([newIndex: groupID])
            }
        }
    }

}

// MARK: -

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
                tableView.insertRows(at: insertions.map(    { IndexPath(row: $0, section: 0)}), with: .none)
                tableView.deleteRows(at: deletions.map(     { IndexPath(row: $0, section: 0)}), with: .none)
                tableView.reloadRows(at: modifications.map( { IndexPath(row: $0, section: 0)}), with: .none)
                tableView.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
