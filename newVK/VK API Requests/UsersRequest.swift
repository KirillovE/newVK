//
//  UsersRequest.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class UsersRequest {
    
    // MARK: - Source data
    
    private var sessionManager: SessionManager?
    let userDefaults = UserDefaults(suiteName: "group.newVK")
    private let method = "users.get"
    private let fields = "photo_100"
    
    // MARK: - Methods
    
    func makeRequest(arrayOfDialogs dialogs: [Message], completion: @escaping ([Message]) -> Void) {
        let (accessToken, apiVersion, url) = configureRequest()
        let userIDs = dialogs.map { String($0.userID) }.joined(separator: ", ")
        let parameters: Parameters = ["user_ids": userIDs,
                                      "fields": fields,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        sessionManager?.request(url! + method, parameters: parameters)
            .responseJSON(queue: DispatchQueue.global()) {response in
                var completeDialogs = [Message]()
                let json = JSON(response.value as Any)["response"].arrayValue
                json.forEach {
                    let id = $0["id"].intValue
                    let firstName = $0["first_name"].stringValue
                    let lastName = $0["last_name"].stringValue
                    let photoURL = $0["photo_100"].stringValue
                    completeDialogs = dialogs.map {
                        if $0.userID == id {
                            $0.firstName = firstName
                            $0.lastName = lastName
                            $0.photoURL = photoURL
                        }
                        return $0
                    }
                }
                completion(completeDialogs)
        }
    }
    
    private func configureRequest() -> (String, Double, String?) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        
        let sharedWrapper = KeychainWrapper(serviceName: "sharedGroup", accessGroup: "group.newVK")
        let accessToken = sharedWrapper.string(forKey: "access_token") ?? ""
        let apiVersion = userDefaults?.double(forKey: "v") ?? 0
        let url = userDefaults?.string(forKey: "apiURL")
        
        return (accessToken, apiVersion, url ?? "")
    }
    
}
