//
//  CheckNewFriendsRequest.swift
//  newVK
//
//  Created by Евгений Кириллов on 16.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class CheckNewFriendsRequest {
    
    // MARK: - Source data
    
    private var sessionManager: SessionManager?
    private let method = "friends.getRequests"
    
    // MARK: - Methods
    
    func makeRequest(completion: @escaping (Int, [Int]) -> Void) {
        let (accessToken, apiVersion, url) = configureRequest()
        
        let parameters: Parameters = ["access_token": accessToken,
                                      "v": apiVersion
        ]
        
        sessionManager?.request(url! + method, parameters: parameters)
            .responseJSON(queue: DispatchQueue.global()) { response in
                guard let data = response.value else { return }
                let json = JSON(data)
                let count = json["response", "count"].intValue
                if count == 0 {
                    completion(0, [])
                } else {
                    let friendIDs = json["response", "items"].arrayValue.map { $0.intValue }
                    completion(count, friendIDs)
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
