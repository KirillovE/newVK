//
//  GroupsService.swift
//  newVK
//
//  Created by Евгений Кириллов on 10.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GroupsService {
    // MARK: - Settings
    
    let version = 5.73
    let accessToken: String!
    let userId: String!
    let vkRequest = VKRequestService()
    
    init(token: String, ID: String) {
        accessToken = token
        userId = ID
    }
    
    // MARK: - Methods
    
    func getGroups() {
        let parameters: Parameters = ["user_id": userId,
                                      "extended": 1,
                                      "access_token": accessToken,
                                      "v": version
        ]
        
        vkRequest.makeRequest(method: "groups.get", parameters: parameters)
    }
    
    func getSearchedGroups(groupToFind q: String, numberOfResults: Int) {
        let parameters: Parameters = ["q": q,
                                      "type": "group",
                                      "count": numberOfResults,
                                      "access_token": accessToken,
                                      "v": version
        ]
        
        vkRequest.makeRequest(method: "groups.search", parameters: parameters)
    }
    
    func appendGroups(from json: JSON) -> [Group] {
        let itemsArray = json["response", "items"]
        var groupsArray = [Group]()
        
        for (_, item) in itemsArray {
            let group = Group(json: item)
            groupsArray.append(group)
        }
        
        return groupsArray
    }
}
