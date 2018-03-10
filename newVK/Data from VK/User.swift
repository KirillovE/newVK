//
//  User.swift
//  newVK
//
//  Created by Евгений Кириллов on 06.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: VKItem {
    var firstName = ""
    var lastName = ""
    var nick = ""
    
    override init(json: JSON) {
        super.init(json: json)
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.nick = json["nickname"].stringValue
    }
}
