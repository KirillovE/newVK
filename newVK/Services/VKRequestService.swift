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
        
//        var newParams = parameters
//        newParams["access_token"] = "123"
        
        sessionManager?.request(url + method, parameters: parameters).responseJSON {response in
            guard let data = response.value else {return}
            let json = JSON(data)
            
            if json["error", "error_code"] == 5 {
                print("не подошёл access_token", json["error", "error_msg"])
                let userDefaults = UserDefaults.standard
                userDefaults.set(false, forKey: "isAuthorized")
//                показать экран входа как-то
//                без этого перехода ошибка исправится при повторном запуске приложения
            } else {
                completion(json)
            }
        }
    }
    
    func configureDefaultSession() -> SessionManager? {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        
        return sessionManager
    }

}
