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
    
    let url = "https://api.vk.com/method"
    let version = 5.73
    let accessToken: Int!
    var sessionManager: SessionManager?
    
    // MARK: - base methods
    
    init(token: Int) {
        accessToken = token
    }
    
    func makeRequest(method: String, parameters: Parameters) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        
        sessionManager?.request(url, parameters: parameters).responseJSON {response in
            print(response.value ?? "No answer")
        }
    }
    
    // MARK: - VK API methods
    
    ///печатает JSON с перечнем друзей
    func getFriends() {
        let parameters: Parameters = ["fields": "nickName",
                                      "access_token": accessToken,
                                      "v": 5.73
        ]
        
        makeRequest(method: "friends.get", parameters: parameters)
    }
    
    ///печатает JSON с перечнем фотографий
    func getPhotos() {
        let parameters: Parameters = ["owner_id": 470347283,
                                      "access_token": accessToken,
                                      "v": 5.73
        ]
        
        makeRequest(method: "photos.getAll", parameters: parameters)
    }
    
    ///печатает JSON с перечнем групп текущего пользователя
    func getGroups() {
        let parameters: Parameters = ["user_id": 470347283,
                                      "extended": 1,
                                      "access_token": accessToken,
                                      "v": 5.73
        ]
        
        makeRequest(method: "groups.get", parameters: parameters)
    }
    
    ///печатает JSON с перечнем групп в соответствии с поисковым запросом
    func getSearchedGroups(_ q: String, numberOfResults: Int) {
        let parameters: Parameters = ["q": q,
                                      "type": "group",
                                      "count": numberOfResults,
                                      "access_token": accessToken,
                                      "v": 5.73
        ]
        
        makeRequest(method: "groups.search", parameters: parameters)
    }
    
}
