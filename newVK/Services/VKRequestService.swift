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

class VKRequestService {
    
    let url = "https://api.vk.com/method/"
    var sessionManager: SessionManager?
    
    func makeRequest(method: String, parameters: Parameters/*, complition: @escaping ([User]) -> Void*/) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        
        sessionManager?.request(url + method, parameters: parameters).responseJSON {response in
            guard let data = response.value else {
//                complition([])
                return
            }
            
            let json = JSON(data)
            print(json)
            
//            switch method {
//            case "friends.get":
//                let usersArray = self.appendUsers(from: json)
//                complition(usersArray)
//            case "photos.getAll": let photosArray = self.appendPhotos(from: json)
//            case "groups.get", "groups.search": let groupsArray = self.appendGroups(from: json)
//            default: break
//            }
        }
    }

}
