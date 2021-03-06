//
//  FriendAlbumVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import RealmSwift

class FriendAlbumVC: UICollectionViewController {
    
    // MARK: - Source data
    
    var ownerID: Int!
    let photosRequest = PhotosRequest()
    var photos: Results<Photo>!
    var token: NotificationToken?
    let settingPicture = SetPictureToCollectionCell()

    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photosRequest.makeRequest(for: self.ownerID)
        pairCollectionAndRealm()
    }
    
    deinit {
        token?.invalidate()
    }
    
    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendImage", for: indexPath) as! FriendAlbumCell
        cell.configure(for: photos[indexPath.row])
        settingPicture.setPicture(url: photos[indexPath.row].smallPhotoURL, cacheLifeTime: .month, cell: cell, imageView: cell.friendImage, indexPath: indexPath, collection: collectionView)
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowPageView" else { return }
        let photoPages = segue.destination as! ManagePageVC
        photoPages.photoIndex = getLargePhotoIndex(from: sender)
    }

    private func getLargePhotoIndex(from sender: Any?) -> Int {
        let selectedCell = sender as! FriendAlbumCell
        let photoIndex = self.collectionView?.indexPath(for: selectedCell)?.row
        return photoIndex!
    }

}

// MARK: -

extension FriendAlbumVC {
    
    private func pairCollectionAndRealm() {
        guard let realm = try? Realm() else { return }
        photos = realm.objects(Photo.self)
        token = photos.observe { [weak self] changes in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_,  let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map(    { IndexPath(row: $0, section: 0)}))
                    collectionView.deleteItems(at: deletions.map(     { IndexPath(row: $0, section: 0)}))
                    collectionView.reloadItems(at: modifications.map( { IndexPath(row: $0, section: 0)}))
                })
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
