//
//  Group.swift
//  newVK
//
//  Created by Евгений Кириллов on 06.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation
import SwiftyJSON

class Group {
    var id = 0
    var name = ""
    var photoURL = ""
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.photoURL = json["photo_50"].stringValue
    }
}
