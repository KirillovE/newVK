//
//  UsersService.swift
//  newVK
//
//  Created by Евгений Кириллов on 10.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FriendsService {
    // MARK: - Settings
    
    let version = 5.73
    let accessToken: String!
    let vkRequest = VKRequestService()
    var friendsJSON: JSON?
    
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
        print(friendsJSON ?? "нет результата")
    }
    
    func appendFriends(from json: JSON) -> [User] {
        let itemsArray = json["response", "items"]
        var usersArray = [User]()
        
        for (_, item) in itemsArray {
            let user = User(json: item)
            usersArray.append(user)
        }
        
        return usersArray
    }
}
