//
//  FriendPhotosVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class FriendPhotosVC: UICollectionViewController {
    
// MARK: - Source data
    
    var albumName = ""
    var photoAlbums = ["друг.Адриана": ["друг.Адриана", "друг.Адриана 1", "друг.Адриана 2"],
                      "друг.Алессандра": ["друг.Алессандра", "друг.Алессандра 1", "друг.Алессандра 2"],
                      "друг.Бекхэм": ["друг.Бекхэм", "друг.Бекхэм 1", "друг.Бекхэм 2"],
                      "друг.В": ["друг.В", "друг.В 1", "друг.В 2", "друг.В 3"],
                      "друг.Ди Каприо": ["друг.Ди Каприо", "друг.Ди Каприо 1", "друг.Ди Каприо 2"],
                      "друг.Дуров": ["друг.Дуров", "друг.Дуров 1", "друг.Дуров 2"],
                      "друг.Маск": ["друг.Маск", "друг.Маск 1", "друг.Маск 2"],
                      "друг.Меган": ["друг.Меган", "друг.Меган 1", "друг.Меган 2", "друг.Меган 3"],
                      "друг.Нео": ["друг.Нео", "друг.Нео 1", "друг.Нео 2"],
                      "друг.Роналду": ["друг.Роналду", "друг.Роналду 1", "друг.Роналду 2"],
                      "друг.Роузи": ["друг.Роузи", "друг.Роузи 1", "друг.Роузи 2", "друг.Роузи 3", "друг.Роузи 4", "друг.Роузи 5"],
                      "друг.Энакин": ["друг.Энакин", "друг.Энакин 1", "друг.Энакин 2"]
    ]

// MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAlbums[albumName]?.count ?? 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendImage", for: indexPath) as! FriendPhotosCell
        
        if let albumToShow = photoAlbums[albumName] {
            cell.friendImage.image = UIImage(named: albumToShow[indexPath.row])
        } else {
            cell.friendImage.image = UIImage(named: albumName)
        }
        
        cell.friendImage.layer.cornerRadius = cell.frame.size.height / 10
        cell.friendImage.clipsToBounds = true
        
        return cell
    }
    
// MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showLargeImage" else { return }
        let largePhotoVC = segue.destination as! LargePhotoVC
        largePhotoVC.photoName = getLargePhotoName(from: sender)
    }
    
    func getLargePhotoName(from sender: Any?) -> String? {
        let selectedCell = sender as! FriendPhotosCell
        let photoIndex = self.collectionView?.indexPath(for: selectedCell)?.row
        let photoName = self.photoAlbums[albumName]?[photoIndex!]
        return photoName
    }

}
