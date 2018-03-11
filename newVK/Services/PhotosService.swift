//
//  PhotosService.swift
//  newVK
//
//  Created by Евгений Кириллов on 10.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PhotosService {
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
    
    func getPhotos() {
//        let parameters: Parameters = ["owner_id": userId,
//                                      "access_token": accessToken,
//                                      "v": version
//        ]
        
//        let photosJSON = vkRequest.makeRequest(method: "photos.getAll", parameters: parameters)
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
}
