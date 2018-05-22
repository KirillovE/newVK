//
//  Photo.swift
//  newVK
//
//  Created by Евгений Кириллов on 06.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class Photo: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var ownerId = 0
    @objc dynamic var smallPhotoURL = ""
    @objc dynamic var largePhotoURL = ""
    
    convenience init(json: JSON) {
        self.init()
        
        id = json["id"].intValue
        ownerId = json["owner_id"].intValue
        smallPhotoURL = json["photo_130"].stringValue
        largePhotoURL = json["photo_604"].stringValue
    }
    
    @objc open override class func primaryKey() -> String? { return "id" }
    
}
