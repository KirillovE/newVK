//
//  MessagesRequest.swift
//  newVK
//
//  Created by Евгений Кириллов on 12.06.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class MessagesRequest {
    
    // MARK: - Source data
    
    private var sessionManager: SessionManager?
    private let userDefaults = UserDefaults(suiteName: "group.newVK")
    private let method = "messages.getHistory"
    
    // MARK: - Methods
    
    func makeRequest(dialogWith interlocutor: Int, completion: @escaping ([Message]) -> Void) {
        let (accessToken, apiVersion, url) = configureRequest()
        let parameters: Parameters = ["user_id": interlocutor,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        sessionManager?.request(url! + method, parameters: parameters)
            .responseJSON(queue: DispatchQueue.global()) { response in
                let json = JSON(response.value as Any)["response", "items"].arrayValue
                let dialogs = json.map { Message(json: $0) }
                completion(dialogs)
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
