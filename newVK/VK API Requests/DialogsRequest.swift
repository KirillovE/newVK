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
    let userDefaults = UserDefaults.standard
    private let method = "messages.getDialogs"
    
    // MARK: - Methods
    
    func makeRequest(completion: @escaping ([Message]) -> Void) {
        let (accessToken, apiVersion, url) = configureRequest()
        
        let parameters: Parameters = ["access_token": accessToken,
                                      "v": apiVersion
        ]
        
        sessionManager?.request(url! + method,
                                parameters: parameters).responseJSON(queue: DispatchQueue.global())
                                {[weak self] response in
                                    guard let data = response.value else { return }
                                    let json = JSON(data)
                                    guard let dialogs = self?.appendDialogs(from: json) else { return }
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
    
    private func appendDialogs(from json: JSON?) -> [Message] {
        return []
    }
    
}
