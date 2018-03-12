//
//  FriendsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Alamofire
import SwiftyJSON

class FriendsVC: UITableViewController {

// MARK: - Source data

    var settings: SettingsStorage!
    let vkRequest = VKRequestService()
    var friends = [User]()
    var friendsJSON: JSON? {
        didSet {
            friends = appendFriends(from: friendsJSON)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFriends()
    }
    
// MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friends", for: indexPath)
        
        let firstName = friends[indexPath.row].firstName
        let lastName = friends[indexPath.row].lastName
        cell.textLabel?.text = firstName
        cell.detailTextLabel?.text = lastName
        
//        пока есть только адрес фотографии, сам файл предстоит получить
//        let friendImageName = friendsList[indexPath.row].imageName
//        cell.imageView?.image = UIImage.init(named: friendImageName)
//        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 2
//        cell.imageView?.clipsToBounds = true
        return cell
    }

// MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowFriendImage" {
//            let cell = sender as! UITableViewCell
//            let imageIndex = self.tableView.indexPath(for: cell)?.row
//            let collectionVC = segue.destination as! FriendPhotosVC
//            collectionVC.albumName = friendsList[imageIndex!].imageName
//            collectionVC.title = friendsList[imageIndex!].name
//        }
//    }
}

// MARK: - Requesting friends from server

extension FriendsVC {
    func getFriends() {
        let parameters: Parameters = ["fields": "nickName",
                                      "access_token": settings.accessToken,
                                      "v": settings.apiVersion
        ]
        
        vkRequest.makeRequest(method: "friends.get", parameters: parameters) { [weak self] json in
            self?.friendsJSON = json
        }
    }
    
    func appendFriends(from json: JSON?) -> [User] {
        guard json != nil else { return [User]() }
        
        let itemsArray = json!["response", "items"]
        var friendsArray = [User]()
        
        for (_, item) in itemsArray {
            let user = User(json: item)
            friendsArray.append(user)
        }
        
        return friendsArray
    }
}
