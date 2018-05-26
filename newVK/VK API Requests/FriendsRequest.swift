//
//  FriendsRequest.swift
//  newVK
//
//  Created by Евгений Кириллов on 03.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

class FriendsRequest {
    
    private var sessionManager: SessionManager?
    private let method = "friends.get"
    private let requestFields = "photo_100, online"
    let userDefaults = UserDefaults(suiteName: "group.newVK")
    
    func makeRequest() {
        let (accessToken, apiVersion, url) = configureRequest()
        
        let parameters: Parameters = ["fields": requestFields,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        sessionManager?.request(url! + method,
                                parameters: parameters).responseJSON(queue: DispatchQueue.global())
                                {[weak self] response in
                                    guard let data = response.value else {return}
                                    let json = JSON(data)
                                    let friends = self?.appendFriends(json: json)
                                    let saving = SavingObjects()
                                    saving.save(objectsArray: friends!)
        }
    }
    
    private func configureRequest() -> (String, Double, String?) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        
        let sharedWrapper = KeychainWrapper(serviceName: "sharedGroup", accessGroup: "group.newVK")
        let accessToken = sharedWrapper.string(forKey: "access_token") ?? ""
        let apiVersion = userDefaults?.double(forKey: "v") ?? 0
        let url = userDefaults?.string(forKey: "apiURL")
        
        return (accessToken, apiVersion, url ?? "")
    }
    
    private func appendFriends(json: JSON) -> [User] {
        guard json["error", "error_code"] != 5 else {
            print("не подошёл access_token ", json["error", "error_msg"])            
            userDefaults?.set(false, forKey: "isAuthorized")
            return [User]()
        }
        
        let itemsArray = json["response", "items"]
        var friendsArray = [User]()
        for (_, item) in itemsArray {
            let user = User(json: item)
            friendsArray.append(user)
        }
        
        return friendsArray
    }

}
