//
//  Photo.swift
//  newVK
//
//  Created by Евгений Кириллов on 06.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation
import SwiftyJSON

class Photo {
    var id = 0
    var ownerId = 0
    var smallPhotoURL = ""
    var largePhotoURL = ""
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.ownerId = json["owner_id"].intValue
        self.smallPhotoURL = json["photo_75"].stringValue
        self.largePhotoURL = json["photo_604"].stringValue
    }
}
