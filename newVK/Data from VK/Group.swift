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
        id = json["id"].intValue
        name = json["name"].stringValue
        photoURL = json["photo_50"].stringValue
    }
}
