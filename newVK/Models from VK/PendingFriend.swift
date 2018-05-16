//
//  PendingFriend.swift
//  newVK
//
//  Created by Евгений Кириллов on 16.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import RealmSwift

class PendingFriends: Object {
    @objc dynamic var id = 0
    
    convenience init(id: Int) {
        self.init()
        self.id = id
    }
    
    @objc open override class func primaryKey() -> String? { return "id" }
}
