//
//  VKRequestService.swift
//  newVK
//
//  Created by Евгений Кириллов on 03.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Alamofire
import SwiftyJSON

class VKRequestService {
    
    let url = "https://api.vk.com/method/"
    var sessionManager: SessionManager?
    
    func makeRequest(method: String, parameters: Parameters, completion: @escaping (_ users: JSON) -> Void) {
        sessionManager = configureDefaultSession()
        
        sessionManager?.request(url + method, parameters: parameters).responseJSON {response in
            guard let data = response.value else {return}
            completion(JSON(data))
        }
    }
    
    func configureDefaultSession() -> SessionManager? {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        
        return sessionManager
    }

}
