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
        newsRequest.makeRequest(filter: newsFilter, resultsCount: 20) { [weak self] news in
            let newsTexts = news
                .filter { $0.text != "" }
                .map { $0.text.padding(toLength: 30, withPad: " ", startingAt: 0) }
                .reduce("🗞 ", { $0 + $1 + "\n\n🗞 " })
            DispatchQueue.main.async {
                self?.newsText.text = newsTexts
            }
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    @IBAction func openAppPressed(_ sender: UIButton) {
        extensionContext?.open(URL(string: "RunFromWidget://")!)
    }
}
