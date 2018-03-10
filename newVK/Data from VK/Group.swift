//
//  Group.swift
//  newVK
//
//  Created by Евгений Кириллов on 06.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation
import SwiftyJSON

class Group: VKItem {
    var name = ""
    var photoURL = ""
    
    override init(json: JSON) {
        super.init(json: json)
        name = json["name"].stringValue
        photoURL = json["photo_50"].stringValue
    }
}
