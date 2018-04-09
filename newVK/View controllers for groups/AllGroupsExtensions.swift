//
//  AllGroupsExtensions.swift
//  newVK
//
//  Created by Евгений Кириллов on 09.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit

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
