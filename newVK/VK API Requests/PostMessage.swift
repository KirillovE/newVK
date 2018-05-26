//
//  PostMessage.swift
//  newVK
//
//  Created by Евгений Кириллов on 13.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class PostMessage {
    
    // MARK: - Source data
    
    private var sessionManager: SessionManager?
    private let method = "wall.post"
    
    // MARK: - Methods
    
    func makeRequest(textToPost message: String, latitude: Double = 0, longitude: Double = 0, completion: @escaping (Bool) -> Void) {
        let (accessToken, apiVersion, url) = configureRequest()
        
        let parameters: Parameters = ["message": message,
                                      "access_token": accessToken,
                                      "v": apiVersion,
                                      "lat": latitude,
                                      "long": longitude
        ]
        
        sessionManager?.request(url! + method,
                                parameters: parameters)
            .responseJSON(queue: DispatchQueue.global()) { response in
                guard let data = response.value else { return }
                let json = JSON(data)
                if json["response", "post_id"].int != nil {
                    completion(true)
                } else {
                    completion(false)
                }
        }
    }
    
    private func configureRequest() -> (String, Double, String?) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        
        let sharedWrapper = KeychainWrapper(serviceName: "sharedGroup", accessGroup: "group.newVK")
        let accessToken = sharedWrapper.string(forKey: "access_token") ?? ""
        let userDefaults = UserDefaults(suiteName: "group.newVK")
        let apiVersion = userDefaults?.double(forKey: "v") ?? 0
        let url = userDefaults?.string(forKey: "apiURL")
        
        return (accessToken, apiVersion, url ?? "")
    }
    
}
