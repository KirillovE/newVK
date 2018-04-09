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

    let formatter: NumberFormatter = {
        let fmtr = NumberFormatter()
        fmtr.usesGroupingSeparator = true
        fmtr.numberStyle = .decimal
        return fmtr
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
        cell.detailTextLabel?.text = "Подписчиков: " + formatInt(membersCount)
        
        cell.configure(for: groups[indexPath.row])

        return cell
    }
}

// MARK: - Extensions

extension AllGroupsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            groups.removeAll(keepingCapacity: false)
            self.tableView.reloadData()
            return
        }
        
        DispatchQueue.global().async {
            self.searchRequest.makeRequest(groupToFind: searchText, numberOfResults: self.numberOfResultsToShow) { [weak self] groups in
                self?.groups = groups
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        groups.removeAll(keepingCapacity: false)
        self.tableView.reloadData()
    }
    
}

extension AllGroupsVC {
    
    func formatInt(_ number: Int) -> String {
        let niceNumber = formatter.string(from: NSNumber(integerLiteral: number))
        
        if let niceString = niceNumber {
            return niceString
        } else {
            return "нет данных"
        }
    }
    
}
