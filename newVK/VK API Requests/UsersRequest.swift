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
    private let userDefaults = UserDefaults.standard
    private let method = "users.get"
    private let fields = "photo_100"
    
    typealias UserDictionary = [Int: [String]]
    
    // MARK: - Methods
    
    func makeRequest(arrayOfIDs ids: [Int], completion: @escaping (UserDictionary) -> Void) {
        let (accessToken, apiVersion, url) = configureRequest()
        let userIDs = ids.map { String($0) }.joined(separator: ", ")
        
        let parameters: Parameters = ["user_ids": userIDs,
                                      "fields": fields,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        sessionManager?.request(url! + method,
                                parameters: parameters).responseJSON(queue: DispatchQueue.global())
                                {response in
                                    var userInfo: UserDictionary = [:]
                                    let json = JSON(response.value as Any)["response"].arrayValue
                                    json.forEach {
                                        let id = $0["id"].intValue
                                        let firstName = $0["first_name"].stringValue
                                        let lastName = $0["last_name"].stringValue
                                        let photo = $0["photo_100"].stringValue
                                        userInfo[id] = [firstName, lastName, photo]
                                    }
                                    completion(userInfo)
        }
    }
    
    private func configureRequest() -> (String, Double, String?) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        
        let accessToken = KeychainWrapper.standard.string(forKey: "access_token")!
        let apiVersion = userDefaults.double(forKey: "v")
        let url = userDefaults.string(forKey: "apiURL")
        
        return (accessToken, apiVersion, url ?? "")
    }
    
}
