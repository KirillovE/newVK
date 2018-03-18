//
//  User.swift
//  newVK
//
//  Created by Евгений Кириллов on 06.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftyJSON
import RealmSwift

class User: Object {
    @objc dynamic var id = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var nick = ""
    @objc dynamic var avatarURL = ""
    var avatar: UIImage?
    
    convenience init(json: JSON) {
        self.init()
        
        id = json["id"].intValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        nick = json["nickname"].stringValue
        avatarURL = json["photo_100"].stringValue
        loadPhoto(from: avatarURL)
    }
    
    @objc open override class func primaryKey() -> String? { return "id" }
}

// MARK: -

extension User {

    func loadPhoto(from urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url!) else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                self.avatar = image
            }
        }
    }
    
}
