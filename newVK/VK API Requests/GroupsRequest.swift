//
//  GroupsRequest.swift
//  newVK
//
//  Created by Евгений Кириллов on 03.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class GroupsRequest {
    
    private var sessionManager: SessionManager?
    
    func getGroups() {
        let method = "groups.get"
        let requestExtended = 1
        let requestFields = "members_count"
        
        let (accessToken, userID, apiVersion, url) = configureRequest()
        
        let parameters: Parameters = ["user_id": userID,
                                      "extended": requestExtended,
                                      "fields": requestFields,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        sessionManager?.request(url! + method,
                                parameters: parameters).responseJSON(queue: DispatchQueue.global())
                                {[weak self] response in
                                    guard let data = response.value else {return}
                                    let json = JSON(data)
                                    let groups = self?.appendGroups(json: json)
                                    let saving = SavingObjects()
                                    saving.save(objectsArray: groups!)
        }
    }
    
    private func configureRequest() -> (String, String, Double, String?) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        
        let accessToken = KeychainWrapper.standard.string(forKey: "access_token")!
        let userDefaults = UserDefaults.standard
        let userID = userDefaults.string(forKey: "user_id")
        let apiVersion = userDefaults.double(forKey: "v")
        let url = userDefaults.string(forKey: "apiURL")
        
        return (accessToken, userID ?? "", apiVersion, url ?? "")
    }
    
    private func appendGroups(json: JSON) -> [Group] {
        guard json["error", "error_code"] != 5 else {
            print("не подошёл access_token ", json["error", "error_msg"])
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "isAuthorized")
            return [Group]()
        }
        
        let itemsArray = json["response", "items"]
        var groupsArray = [Group]()
        for (_, item) in itemsArray {
            let group = Group(json: item)
            groupsArray.append(group)
        }
        
        return groupsArray
    }

}

extension GroupsRequest {
    
    func leaveGroup(groupID: Int) {
        let method = "groups.leave"
        let (accessToken, _, apiVersion, url) = configureRequest()
        
        let parameters: Parameters = ["group_id": groupID,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        sessionManager?.request(url! + method, parameters: parameters)
    }
    
}

extension GroupsRequest {

    func joinGroup(groupID: Int) {
        let method = "groups.join"
        let (accessToken, _, apiVersion, url) = configureRequest()

        let parameters: Parameters = ["group_id": groupID,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]

        sessionManager?.request(url! + method, parameters: parameters)
    }

}

