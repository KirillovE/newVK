//
//  SettingsStorage.swift
//  newVK
//
//  Created by Евгений Кириллов on 11.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

class SettingsStorage {
    var accessToken, userID: String
    var apiVersion: Double
    
    init(token: String, id: String, version: Double) {
        accessToken = token
        userID = id
        apiVersion = version
    }
}
