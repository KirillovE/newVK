//
//  Group.swift
//  newVK
//
//  Created by Евгений Кириллов on 06.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class Group: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var photoURL = ""
    @objc dynamic var membersCount = 0
    
    convenience init(json: JSON) {
        self.init()
        
        id = json["id"].intValue
        name = json["name"].stringValue
        photoURL = json["photo_100"].stringValue
        membersCount = json["members_count"].intValue
    }
    
    @objc open override class func primaryKey() -> String? { return "id" }
    
}
