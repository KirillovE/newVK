//
//  VKservice.swift
//  newVK
//
//  Created by Евгений Кириллов on 03.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation
import Alamofire

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
            print("\n--- Response for method '\(method)' is ---\n", response.value ?? "No answer")
            self.sessionManager = nil
        }
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
