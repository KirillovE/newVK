//
//  User.swift
//  newVK
//
//  Created by Евгений Кириллов on 06.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftyJSON

class User {
    var id = 0
    var firstName = ""
    var lastName = ""
    var nick = ""
    
    init(json: JSON) {
        id = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.nick = json["nickname"].stringValue
    }
}
