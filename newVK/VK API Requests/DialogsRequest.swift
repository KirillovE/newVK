//
//  DialogsRequest.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class DialogsRequest {
    
    // MARK: - Source data
    
    private var sessionManager: SessionManager?
    private let userDefaults = UserDefaults.standard
    private let method = "messages.getDialogs"
    private let previewLength = 50
    
    // MARK: - Methods
    
    func makeRequest(completion: @escaping ([Message]) -> Void) {
        let (accessToken, apiVersion, url) = configureRequest()
        let parameters: Parameters = ["preview_length": previewLength,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        sessionManager?.request(url! + method, parameters: parameters)
            .responseJSON(queue: DispatchQueue.global()) {response in
                let json = JSON(response.value as Any)["response", "items"].arrayValue
                let dialogs = json.map { Message(json: $0["message"]) }
                completion(dialogs)
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
