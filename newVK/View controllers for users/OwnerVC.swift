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
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        let ownerID = userDefaults.integer(forKey: "user_id")
        photosRequest.makeRequest(for: ownerID)
        pairCollectionAndRealm()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    @IBAction func leavePressed(_ sender: UIBarButtonItem) {
        leaveRequest.logOut()
        self.tabBarController?.dismiss(animated: true)
    }
}

// MARK: -

extension OwnerVC {
    
    func pairCollectionAndRealm() {
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