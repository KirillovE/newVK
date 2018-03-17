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
    var photo: UIImage?
    
    convenience init(json: JSON) {
        self.init()
        
        id = json["id"].intValue
        name = json["name"].stringValue
        photoURL = json["photo_100"].stringValue
        membersCount = json["members_count"].intValue
        loadPhoto(from: photoURL)
    }
    
    @objc open override class func primaryKey() -> String? { return "id" }
    
}

// MARK: -

extension Group {
    func loadPhoto(from urlString: String) {
        let url = URL(string: photoURL)
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url!) else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                self.photo = image
            }
        }
    }
    
}
