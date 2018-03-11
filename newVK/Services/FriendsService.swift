//
//  FriendsService.swift
//  newVK
//
//  Created by Евгений Кириллов on 10.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Alamofire
import SwiftyJSON

class FriendsService {
    // MARK: - Settings
    
    let version = 5.73
    let accessToken: String!
    let vkRequest = VKRequestService()
    var friends = [User]()
    var friendsJSON: JSON? {
        didSet {
            friends = appendFriends(from: friendsJSON)
        }
    }
    
    init(token: String) {
        accessToken = token
    }
    
    // MARK: - Methods
    
    func getFriends() {
        let parameters: Parameters = ["fields": "nickName",
                                      "access_token": accessToken,
                                      "v": version
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
