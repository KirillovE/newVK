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
    
    func makeRequest(textToPost message: String, completion: @escaping (Bool) -> Void) {
        let (accessToken, apiVersion, url) = configureRequest()
        
        let parameters: Parameters = ["message": message,
                                      "access_token": accessToken,
                                      "v": apiVersion
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
        
        let accessToken = KeychainWrapper.standard.string(forKey: "access_token")!
        let userDefaults = UserDefaults.standard
        let apiVersion = userDefaults.double(forKey: "v")
        let url = userDefaults.string(forKey: "apiURL")
        
        return (accessToken, apiVersion, url ?? "")
    }
    
}
