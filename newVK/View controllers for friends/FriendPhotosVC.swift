//
//  FriendPhotosVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 23.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Alamofire
import SwiftyJSON
import RealmSwift

class FriendPhotosVC: UICollectionViewController {
    
    // MARK: - Source data
    
    var ownerID: Int!
    let vkRequest = VKRequestService()
    var photos = [Photo]()
    var photosJSON: JSON? {
        didSet {
            photos = appendPhotos(from: photosJSON)
            self.collectionView?.reloadData()
        }
    }

    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos()
    }
    
    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendImage", for: indexPath) as! FriendPhotosCell
        
        let photo = photos[indexPath.row].largePhoto
        cell.friendImage.image = photo
        
        cell.friendImage.layer.cornerRadius = cell.frame.size.height / 10
        cell.friendImage.clipsToBounds = true
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowPageView" else { return }
        let photoPages = segue.destination as! ManagePageVC
        photoPages.photoAlbum = photos
        photoPages.photoIndex = getLargePhotoIndex(from: sender)
    }

    func getLargePhotoIndex(from sender: Any?) -> Int {
        let selectedCell = sender as! FriendPhotosCell
        let photoIndex = self.collectionView?.indexPath(for: selectedCell)?.row
        return photoIndex!
    }

}

// MARK: - Requesting photos from server

extension FriendPhotosVC {
    
    func getPhotos() {
        let userDefaults = UserDefaults.standard
        let accessToken = userDefaults.string(forKey: "access_token")!
        let apiVersion = userDefaults.double(forKey: "v")
        
        let parameters: Parameters = ["owner_id": ownerID,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        vkRequest.makeRequest(method: "photos.getAll", parameters: parameters)  { [weak self] json in
            self?.photosJSON = json
        }
    }
    
    func appendPhotos(from json: JSON?) -> [Photo] {
        let itemsArray = json!["response", "items"]
        var photosArray = [Photo]()
        
        for (_, item) in itemsArray {
            let photo = Photo(json: item)
            photosArray.append(photo)
        }
        
        savePhotos(photosArray)
        return photosArray
    }
    
}

// MARK: - Saving data to Realm data base

extension FriendPhotosVC {
    
    func savePhotos(_ photos: [Photo]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(photos)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
}
