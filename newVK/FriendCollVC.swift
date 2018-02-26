//
//  FriendCollVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class FriendCollVC: UICollectionViewController {
    
    var albumName = ""
    var photoAlbum = ["друг.Адриана": ["друг.Адриана", "друг.Адриана 1", "друг.Адриана 2"],
                      "друг.Алессандра": ["друг.Алессандра", "друг.Алессандра 1", "друг.Алессандра 2"],
                      "друг.Бекхэм": ["друг.Бекхэм", "друг.Бекхэм 1", "друг.Бекхэм 2"],
                      "друг.В": ["друг.В", "друг.В 1", "друг.В 2"],
                      "друг.Ди Каприо": ["друг.Ди Каприо", "друг.Ди Каприо 1", "друг.Ди Каприо 2"],
                      "друг.Дуров": ["друг.Дуров", "друг.Дуров 1", "друг.Дуров 2"],
                      "друг.Маск": ["друг.Маск", "друг.Маск 1", "друг.Маск 2"],
                      "друг.Меган": ["друг.Меган", "друг.Меган 1", "друг.Меган 2"],
                      "друг.Нео": ["друг.Нео", "друг.Нео 1", "друг.Нео 2"],
                      "друг.Роналду": ["друг.Роналду", "друг.Роналду 1", "друг.Роналду 2"],
                      "друг.Роузи": ["друг.Роузи", "друг.Роузи 1", "друг.Роузи 2"],
                      "друг.Энакин": ["друг.Энакин", "друг.Энакин 1", "друг.Энакин 2"]
    ]

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAlbum[albumName]?.count ?? 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendImage", for: indexPath) as! FriendCollVCell
        
        if let albumToShow = photoAlbum[albumName] {
            cell.friendImage.image = UIImage(named: albumToShow[indexPath.row])
        } else {
            cell.friendImage.image = UIImage(named: albumName)
        }
        
        cell.bounds.size.width = cell.bounds.size.height
        return cell
    }
    
}
