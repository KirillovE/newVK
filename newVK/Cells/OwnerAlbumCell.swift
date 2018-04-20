//
//  OwnerAlbumCell.swift
//  newVK
//
//  Created by Евгений Кириллов on 21.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class OwnerAlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var ownerPhoto: UIImageView!
    
    func configure(for photo: Photo) {    
        ownerPhoto.layer.cornerRadius = frame.size.height / 10
    }
    
}

