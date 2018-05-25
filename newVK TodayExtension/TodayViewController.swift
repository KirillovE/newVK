//
//  TodayViewController.swift
//  newVK TodayExtension
//
//  Created by Евгений Кириллов on 25.05.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var newsText: UILabel!
    let newsRequest = NewsRequest()
    let newsFilter = "post"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsRequest.makeRequest(filter: newsFilter) { [weak self] news in
            self?.newsText.text = news.first?.text
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
