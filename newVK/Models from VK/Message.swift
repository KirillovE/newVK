//
//  Message.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftyJSON

class Message {
    
    private let id: Int
    let body: String
    let userID: Int
    let date: Double
    let readState: Bool
    let out: Bool
    var firstName = ""
    var lastName = ""
    var photoURL = ""
        
    init(json: JSON) {
        id = json["id"].intValue
        body = json["body"].stringValue
        userID = json["user_id"].intValue
        date = json["date"].doubleValue
        readState = json["read_state"].boolValue
        out = json["out"].boolValue
    }
    
}
