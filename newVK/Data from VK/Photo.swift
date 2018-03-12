//
//  Photo.swift
//  newVK
//
//  Created by Евгений Кириллов on 06.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftyJSON

class Photo {
    var id = 0
    var ownerId = 0
    var smallPhotoURL = ""
    var largePhotoURL = ""
    
    init(json: JSON) {
        id = json["id"].intValue
        ownerId = json["owner_id"].intValue
        smallPhotoURL = json["photo_75"].stringValue
        largePhotoURL = json["photo_604"].stringValue
    }
}
