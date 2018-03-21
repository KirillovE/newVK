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
    private let requestFields = "nickName,photo_100"
    
    func makeRequest() {
        let (accessToken, apiVersion, url) = configureRequest()
        
        let parameters: Parameters = ["fields": requestFields,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        sessionManager?.request(url! + method, parameters: parameters).responseJSON {[weak self] response in
            guard let data = response.value else {return}
            let json = JSON(data)
            let friends = self?.appendFriends(json: json)
            let saving = SavingObjects()
            saving.save(objectsArray: friends!)
        }
    }
    
    /// подготавливает настройки для запроса
    private func configureRequest() -> (String, Double, String?) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        
        let accessToken = KeychainWrapper.standard.string(forKey: "access_token")!
        let userDefaults = UserDefaults.standard
        let apiVersion = userDefaults.double(forKey: "v")
        let url = userDefaults.string(forKey: "apiURL")
        
        return (accessToken, apiVersion, url ?? "")
    }
    
    /// выдаёт массив друзей
    private func appendFriends(json: JSON) -> [User] {
        guard json["error", "error_code"] != 5 else {
            print("не подошёл access_token ", json["error", "error_msg"])
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "isAuthorized")
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
