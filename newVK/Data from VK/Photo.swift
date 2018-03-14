//
//  Photo.swift
//  newVK
//
//  Created by Евгений Кириллов on 06.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftyJSON

class Photo {
    @objc dynamic var id = 0
    @objc dynamic var ownerId = 0
    @objc dynamic private var smallPhotoURL = ""
    @objc dynamic private var largePhotoURL = ""
    @objc dynamic var smallPhoto, largePhoto: UIImage?
    
    convenience init(json: JSON) {
        self.init()
        
        id = json["id"].intValue
        ownerId = json["owner_id"].intValue
        smallPhotoURL = json["photo_130"].stringValue
        largePhotoURL = json["photo_604"].stringValue
        loadSmallPhoto(from: smallPhotoURL)
        loadLargePhoto(from: largePhotoURL)
    }
    
}

// MARK: -

extension Photo {
    
    private func loadLargePhoto(from urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                guard let image = UIImage(data: data!) else { return }
                self.largePhoto = image
            }
        }
    }
    
    private func loadSmallPhoto(from urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                guard let image = UIImage(data: data!) else { return }
                self.smallPhoto = image
            }
        }
    }

}
