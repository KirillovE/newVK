//
//  APImethodsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 04.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class APImethodsVC: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var friendsButton: UIButton!
    @IBOutlet weak var photosButton: UIButton!
    @IBOutlet weak var groupsButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Source data
    
    var accessToken: String!
    var userID: String!
    var userService: UsersService!
    var photoService: PhotosService!
    var groupService: GroupsService!
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsButton.layer.cornerRadius = 5
        photosButton.layer.cornerRadius = 5
        groupsButton.layer.cornerRadius = 5
        
        searchBar.delegate = self
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardGesture)
    }
    
    // MARK: - Methods
    
    @IBAction func friendsPressed(_ sender: UIButton) {
        userService = UsersService(token: accessToken)
        userService.getFriends()
    }
    
    @IBAction func photosPressed(_ sender: UIButton) {
        photoService = PhotosService(token: accessToken, ID: userID)
        photoService.getPhotos()
    }
    
    @IBAction func groupsPressed(_ sender: UIButton) {
        groupService = GroupsService(token: accessToken, ID: userID)
        groupService.getGroups()
    }
    
}

// MARK: - Extensions

extension APImethodsVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text != nil else {
            return
        }
        
        groupService = GroupsService(token: accessToken, ID: userID)
        groupService.getSearchedGroups(groupToFind: searchBar.text!, numberOfResults: 3)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
