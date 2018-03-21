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

class PhotosRequest {
    
    private var sessionManager: SessionManager?
    private let method = "photos.getAll"
    
    func makeRequest(for ownerID: Int) {
        let (accessToken, apiVersion, url) = configureRequest()
        
        let parameters: Parameters = ["owner_id": ownerID,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        sessionManager?.request(url! + method, parameters: parameters).responseJSON {[weak self] response in
            guard let data = response.value else {return}
            let json = JSON(data)
            let photos = self?.appendPhotos(json: json)
            let saving = SavingObjects()
            saving.save(objectsArray: photos!)
        }
    }
    
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
    
    private func appendPhotos(json: JSON) -> [Photo] {
        guard json["error", "error_code"] != 5 else {
            print("не подошёл access_token ", json["error", "error_msg"])
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "isAuthorized")
            return [Photo]()
        }
        
        let itemsArray = json["response", "items"]
        var photosArray = [Photo]()
        for (_, item) in itemsArray {
            let photo = Photo(json: item)
            photosArray.append(photo)
        }
        
        return photosArray
    }

}

