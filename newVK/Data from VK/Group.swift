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
    var photo: UIImage?
    
    convenience init(json: JSON) {
        self.init()
        
        id = json["id"].intValue
        name = json["name"].stringValue
        photoURL = json["photo_100"].stringValue
        loadPhoto(from: photoURL)
    }
}

// MARK: -

extension Group {
    func loadPhoto(from urlString: String) {
        let url = URL(string: photoURL)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                guard let image = UIImage(data: data!) else { return }
                self.photo = image
            }
        }
    }
    
}
