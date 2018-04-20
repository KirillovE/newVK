//
//  FriendAlbumCell.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class FriendAlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var friendImage: UIImageView!
    
    func configure(for photo: Photo) {        
        friendImage.layer.cornerRadius = frame.size.height / 10
    }
    
}
