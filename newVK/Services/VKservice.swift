//
//  VKservice.swift
//  newVK
//
//  Created by Евгений Кириллов on 03.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class VKservice {
    // MARK: - Source data
    
    let url = "https://api.vk.com/method/"
    let version = 5.73
    let accessToken: String!
    let userId: String!
    var sessionManager: SessionManager?
    
    // MARK: - base methods
    
    init(token: String, ID: String) {
        accessToken = token
        userId = ID
    }
    
    func makeRequest(method: String, parameters: Parameters) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        
        sessionManager?.request(url + method, parameters: parameters).responseJSON {response in
            guard let data = response.value else {return}
            let json = JSON(data)
            
            switch method {
            case "friends.get":
                let usersArray = self.appendUsers(from: json)
                print(usersArray)
            case "photos.getAll":
                let photosArray = self.appendPhotos(from: json)
                print(photosArray)
            case "groups.get", "groups.search":
                let groupsArray = self.appendGroups(from: json)
                print(groupsArray)
            default: break
            }
        }
    }
    
    // MARK: - Appending arrays from JSON
    
    func appendUsers(from json: JSON) -> [User] {
        let itemsArray = json["response", "items"]
        var usersArray = [User]()
        
        for (_, item) in itemsArray {
            let user = User(json: item)
            usersArray.append(user)
        }
        
        return usersArray
    }
    
    func appendPhotos(from json: JSON) -> [Photo] {
        let itemsArray = json["response", "items"]
        var photosArray = [Photo]()
        
        for (_, item) in itemsArray {
            let photo = Photo(json: item)
            photosArray.append(photo)
        }
        
        return photosArray
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
    
    // MARK: - VK API methods
    
    ///печатает JSON с перечнем друзей
    func getFriends() {
        let parameters: Parameters = ["fields": "nickName",
                                      "access_token": accessToken,
                                      "v": version
        ]
        
        makeRequest(method: "friends.get", parameters: parameters)
    }
    
    ///печатает JSON с перечнем фотографий
    func getPhotos() {
        let parameters: Parameters = ["owner_id": userId,
                                      "access_token": accessToken,
                                      "v": version
        ]
        
        makeRequest(method: "photos.getAll", parameters: parameters)
    }
    
    ///печатает JSON с перечнем групп текущего пользователя
    func getGroups() {
        let parameters: Parameters = ["user_id": userId,
                                      "extended": 1,
                                      "access_token": accessToken,
                                      "v": version
        ]
        
        makeRequest(method: "groups.get", parameters: parameters)
    }
    
    ///печатает JSON с перечнем групп в соответствии с поисковым запросом
    func getSearchedGroups(groupToFind q: String, numberOfResults: Int) {
        let parameters: Parameters = ["q": q,
                                      "type": "group",
                                      "count": numberOfResults,
                                      "access_token": accessToken,
                                      "v": version
        ]
        
        makeRequest(method: "groups.search", parameters: parameters)
    }
    
}
