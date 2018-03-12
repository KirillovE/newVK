//
//  Group.swift
//  newVK
//
//  Created by Евгений Кириллов on 06.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftyJSON

class Group {
    let id: Int
    let name, photoURL: String
    var photo: UIImage?
    
    init(json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        photoURL = json["photo_50"].stringValue
        loadPhotoAsync(from: photoURL)
    }
}

extension Group {
    func loadPhotoAsync(from urlString: String) {
        let url = URL(string: photoURL)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    self.photo = image
                }
            }
        }
    }
    
}
