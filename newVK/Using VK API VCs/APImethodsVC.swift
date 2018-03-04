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
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendsButton.layer.cornerRadius = 5
        photosButton.layer.cornerRadius = 5
        groupsButton.layer.cornerRadius = 5
    }
    
    // MARK: - Methods
    
    @IBAction func friendsPressed(_ sender: UIButton) {
        let vkServices = VKservice(token: accessToken)
        vkServices.getFriends()
    }
    
    @IBAction func photosPressed(_ sender: UIButton) {
        let vkServices = VKservice(token: accessToken)
        vkServices.getPhotos()
    }
    
    @IBAction func groupsPressed(_ sender: UIButton) {
        let vkServices = VKservice(token: accessToken)
        vkServices.getGroups()
    }
    
}
