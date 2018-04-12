//
//  AllGroupsVC.swift
//  newVK
//
//  Created by Евгений Кириллов on 25.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

class AllGroupsVC: UITableViewController {
    
    // MARK: - Source data
    
    @IBOutlet weak var searchBar: UISearchBar!
    let searchRequest = GroupsSearchRequest()
    var groups = [Group]()
    let numberOfResultsToShow = 50

    let formatter = Formatting()
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allGroups", for: indexPath) as! AllGroupsCell
        
        let membersCount = groups[indexPath.row].membersCount
        cell.detailTextLabel?.text = "Подписчиков: " + formatter.formatInt(membersCount)
        
        cell.configure(for: groups[indexPath.row])

        return cell
    }
}
