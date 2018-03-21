//
//  GroupsSearchRequest.swift
//  newVK
//
//  Created by Евгений Кириллов on 21.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class GroupsSearchRequest {
    
    private var sessionManager: SessionManager?
    private let method = "groups.search"
    private let requestExtended = 1
    private let requestFields = "members_count"
    private let requestSort = 0
    
    func makeRequest(groupToFind groupName: String, numberOfResults: Int, completion: @escaping ([Group]) -> Void) {
        let (accessToken, apiVersion, url) = configureRequest()
        
        let parameters: Parameters = ["q": groupName,
                                      "count": numberOfResults,
                                      "extended": requestExtended,
                                      "fields": requestFields,
                                      "sort": requestSort,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        sessionManager?.request(url! + method, parameters: parameters).responseJSON {[weak self] response in
            guard let data = response.value else {return}
            let json = JSON(data)
            guard let groups = self?.appendGroups(from: json) else { return }
            completion(groups)
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
    
    func appendGroups(from json: JSON?) -> [Group] {
        let itemsArray = json!["response", "items"]
        var groupsArray = [Group]()
        
        for (_, item) in itemsArray {
            let group = Group(json: item)
            groupsArray.append(group)
        }
        
        return groupsArray
    }
    
}
