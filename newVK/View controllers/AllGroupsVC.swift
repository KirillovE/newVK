//
//  AllGroupsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 25.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AllGroupsVC: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Source data
    
    var settings: SettingsStorage!
    let vkRequest = VKRequestService()
    var groups = [Group]()
    var groupsJSON: JSON? {
        didSet {
            groups = appendGroups(from: groupsJSON)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allGroups", for: indexPath)
        
        let groupName = groups[indexPath.row].name
        cell.textLabel?.text = groupName
        
//        для получения количества подписчиков нужно реализовать отдельный запрос
//        let groupSubscriberCount = chosenGroup[indexPath.row].subscriberCount
        
//        фотография пока не получена, есть только её адрес
//        let groupImageName = chosenGroup[indexPath.row].imageName
        
//        cell.imageView?.image = UIImage(named: groupImageName)
//        cell.detailTextLabel?.text = "Подписчиков: " + String(groupSubscriberCount)
//
//        cell.imageView?.layer.cornerRadius = cell.frame.size.height / 4
//        cell.imageView?.clipsToBounds = true

        return cell
    }
}

// MARK: - Searching groups

extension AllGroupsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            groups.removeAll(keepingCapacity: false)
            self.tableView.reloadData()
            return
        }
        
        getSearchedGroups(groupToFind: searchText, numberOfResults: 20)
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        groups.removeAll(keepingCapacity: false)
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text != nil else {
            groups.removeAll(keepingCapacity: false)
            self.tableView.reloadData()
            return
        }
        
        getSearchedGroups(groupToFind: searchBar.text!, numberOfResults: 20)
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - Requesting groups from server

extension AllGroupsVC {
    
    func getSearchedGroups(groupToFind q: String, numberOfResults: Int) {
        let parameters: Parameters = ["q": q,
                                      "type": "group",
                                      "count": numberOfResults,
                                      "access_token": settings.accessToken,
                                      "v": settings.apiVersion
        ]
        
        vkRequest.makeRequest(method: "groups.search", parameters: parameters) { [weak self] json in
            self?.groupsJSON = json
        }
    }
    
    func appendGroups(from json: JSON?) -> [Group] {
        let itemsArray = json!["response", "items"]
        var groupsArray = [Group]()
        
        for (_, item) in itemsArray {
            let group = Group(json: item)
            groupsArray.append(group)
        }
        
        return groupsArray
    }
    
}
