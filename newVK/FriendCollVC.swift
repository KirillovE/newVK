//
//  FriendCollVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class FriendCollVC: UICollectionViewController {
    
    var imageName = ""

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendImage", for: indexPath) as! FriendCollVCell
        cell.friendImage.image = UIImage(named: imageName)

        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        cell.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        self.navigationController?.hidesBarsOnTap = true
        
        return cell
    }
    
}
