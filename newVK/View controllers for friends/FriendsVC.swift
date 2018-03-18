//
//  FriendsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift
import SwiftKeychainWrapper

class FriendsVC: UITableViewController {
    
    // MARK: - Source data
    
    let vkRequest = VKRequestService()
    var friends = [User]() {
        didSet {
            for friend in friends {
                friend.loadPhoto(from: friend.avatarURL)
            }
        }
    }
    var friendsJSON: JSON? {
        didSet {
            appendFriends(from: friendsJSON)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriends()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friends", for: indexPath) as! FriendsCell
        cell.configure(for: friends[indexPath.row])
        
        return cell
    }

// MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFriendImage" {
            let cell = sender as! UITableViewCell
            let imageIndex = self.tableView.indexPath(for: cell)?.row
            let collectionVC = segue.destination as! FriendPhotosVC
            collectionVC.ownerID = friends[imageIndex!].id
            collectionVC.title = friends[imageIndex!].firstName
        }
    }

}

// MARK: - Requesting friends from server

extension FriendsVC {
    
    func getFriends() {
        let userDefaults = UserDefaults.standard
        let accessToken = KeychainWrapper.standard.string(forKey: "access_token")!
        let apiVersion = userDefaults.double(forKey: "v")
        
        let parameters: Parameters = ["fields": "nickName,photo_100",
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        vkRequest.makeRequest(method: "friends.get", parameters: parameters) { [weak self] json in
            self?.friendsJSON = json
        }
    }
    
    func appendFriends(from json: JSON?) {        
        let itemsArray = json!["response", "items"]
        var friendsArray = [User]()
        
        for (_, item) in itemsArray {
            let user = User(json: item)
            friendsArray.append(user)
        }
        
        saveFriends(friendsArray)
        loadFriends()
    }
}

// MARK: - Saving data to Realm data base

extension FriendsVC {
    
    /// сохранить друзей в базу данных Realm
    func saveFriends(_ friends: [User]) {
        do {
            let realm = try Realm()
            let oldFriends = realm.objects(User.self)       // сначала нужно удалить старые данные
            realm.beginWrite()
            realm.delete(oldFriends)
            realm.add(friends, update: true)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    /// загрузить друзей из базы данных Realm
    func loadFriends() {
        do {
            let realm = try Realm()
            let friends = realm.objects(User.self)
            self.friends = Array(friends)
        } catch {
            print(error)
        }
    }
    
}
