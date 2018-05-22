//
//  MyGroupsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 25.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import RealmSwift

class MyGroupsVC: UITableViewController {
    
    // MARK: - Source data
    
    let groupsRequest = GroupsRequest()
    var groups: Results<Group>!
    var token: NotificationToken?
    let webImages = ImagesFromWeb()
    
    // MARK: - View controller life cycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        groupsRequest.getGroups()
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
        webImages.setImage(fromPath: groups[indexPath.row].photoURL, to: cell.imageView!)
        
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

    // MARK: -
    
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
                
                let fireBase = WorkWithFirebase()
                fireBase.addGroup(groupToJoin)
            }
        }
    }

}

// MARK: -

extension MyGroupsVC {
    
    private func pairTableAndRealm() {
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
