//
//  TodayTableVC.swift
//  newVK TodayExtension
//
//  Created by Евгений Кириллов on 28.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayTableVC: UITableViewController {

    // MARK: - Source data
    
    let newsRequest = NewsRequest()
    var newsArray = [News]()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        newsRequest.makeRequest(resultsCount: 20) { [weak self] news in
            self?.newsArray = news
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayCell", for: indexPath) as! TodayCell
        cell.configure(withNews: newsArray[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        extensionContext?.open(URL(string: "RunFromWidget://")!)
    }

}

// MARK: - Widget methods

extension TodayTableVC: NCWidgetProviding {
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .expanded:
            preferredContentSize = maxSize
        default:
            preferredContentSize.height = 10
            // не понял, зачем вообще указывать размер для режима ".compact", но без этого не работает
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}
