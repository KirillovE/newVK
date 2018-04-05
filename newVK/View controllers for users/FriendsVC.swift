//
//  FriendsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import RealmSwift

class FriendsVC: UITableViewController {
    
    // MARK: - Source data
    
    let friendsRequest = FriendsRequest()
    var friends: Results<User>!
    var token: NotificationToken?
    let leaveRequest = LeaveAccount()
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            self.friendsRequest.makeRequest()
        }
        pairTableAndRealm()
    }
    
    deinit {
        token?.invalidate()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friends", for: indexPath) as! FriendsCell
        cell.configure(for: friends[indexPath.row])
        
        let getCacheImage = GetCacheImage(url: friends[indexPath.row].avatarURL)
        getCacheImage.completionBlock = {
            OperationQueue.main.addOperation {
                cell.imageView?.image = getCacheImage.outputImage
            }
        }
        queue.addOperation(getCacheImage)
        
        return cell
    }

// MARK: - 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFriendImages" {
            let cell = sender as! FriendsCell
            let imageIndex = self.tableView.indexPath(for: cell)?.row
            let collectionVC = segue.destination as! FriendPhotosVC
            collectionVC.ownerID = friends[imageIndex!].id
            collectionVC.title = friends[imageIndex!].firstName
        }
    }
    
}

// MARK: -

extension FriendsVC {
    
    func pairTableAndRealm() {
        guard let realm = try? Realm() else { return }
        friends = realm.objects(User.self)
        token = friends.observe { [weak self] changes in
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
