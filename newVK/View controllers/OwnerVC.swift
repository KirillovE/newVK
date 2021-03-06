//
//  OwnerVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 21.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import RealmSwift

private let reuseIdentifier = "ownerPhotos"

class OwnerVC: UICollectionViewController {
    
    // MARK: - Source data
    
    let photosRequest = PhotosRequest()
    var photos: Results<Photo>!
    var token: NotificationToken?
    let leaveRequest = LeaveAccount()
    let settingPicture = SetPictureToCollectionCell()
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults(suiteName: "group.newVK")
        let ownerID = userDefaults?.integer(forKey: "user_id") ?? 0
        self.photosRequest.makeRequest(for: ownerID)
        pairCollectionAndRealm()
    }
    
    deinit {
        token?.invalidate()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! OwnerAlbumCell
        cell.configure(for: photos[indexPath.row])
        settingPicture.setPicture(url: photos[indexPath.row].smallPhotoURL, cacheLifeTime: .month, cell: cell, imageView: cell.ownerPhoto, indexPath: indexPath, collection: collectionView)
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showOwnerPages" else { return }
        let photoPages = segue.destination as! ManagePageVC
        photoPages.photoIndex = getLargePhotoIndex(from: sender)
    }
    
    private func getLargePhotoIndex(from sender: Any?) -> Int {
        let selectedCell = sender as! OwnerAlbumCell
        let photoIndex = self.collectionView?.indexPath(for: selectedCell)?.row
        return photoIndex!
    }

}

// MARK: -

extension OwnerVC {
    
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
