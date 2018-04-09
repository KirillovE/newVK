//
//  FriendPhotosCell.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class FriendPhotosCell: UICollectionViewCell {
    
    @IBOutlet weak var friendImage: UIImageView!
    
    func configure(for photo: Photo) {
        loadPhoto(from: photo.smallPhotoURL)
        
        friendImage.layer.cornerRadius = frame.size.height / 10
    }
    
    func loadPhoto(from urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url!) else { return }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else { return }
                self.friendImage.image = image
            }
        }
    }
    
}
