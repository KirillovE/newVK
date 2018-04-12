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
    
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
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
        
        let getCacheImage = GetCacheImage(url: groups[indexPath.row].photoURL)
        let setImageToRow = SetImageToRow(cell: cell, imageView: cell.imageView!, indexPath: indexPath, tableView: tableView)
        setImageToRow.addDependency(getCacheImage)
        queue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)

        return cell
    }
}
