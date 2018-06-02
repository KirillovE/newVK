//
//  InterfaceController.swift
//  WatchExtension Extension
//
//  Created by Евгений Кириллов on 02.06.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var newsTable: WKInterfaceTable!
    var session: WCSession?
    
    override func willActivate() {
        super.willActivate()
        
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
}

extension InterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        guard activationState == .activated else { return }
        session.sendMessage(["request": "News"], replyHandler: { reply in
            guard let news = reply["NewsFeed"] as? [News] else { return }
            self.newsTable.setNumberOfRows(news.count, withRowType: "WatchTable")
        }, errorHandler: nil)
    }
    
}
