//
//  Photo.swift
//  newVK
//
//  Created by Евгений Кириллов on 06.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation
import SwiftyJSON

class Photo: VKItem {
    var ownerId = 0
    var smallPhotoURL = ""
    var largePhotoURL = ""
    
    override init(json: JSON) {
        super.init(json: json)
        ownerId = json["owner_id"].intValue
        smallPhotoURL = json["photo_75"].stringValue
        largePhotoURL = json["photo_604"].stringValue
    }
}
