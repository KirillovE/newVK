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
    var newsStructs = [NewsStruct]()
    
    override func willActivate() {
        super.willActivate()
        setSession()
    }
    
    fileprivate func setSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
}

extension InterfaceController: WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        guard activationState == .activated else {
            print("Not connected")
            return
        }

        session.sendMessage(["request": "News"], replyHandler: { reply in
            guard let news = reply["newsFeed"] as? [[String: String]] else { return }
            
            self.newsStructs = news.map {
                NewsStruct(author: $0["author"] ?? "",
                           text: $0["text"] ?? "",
                           avatar: $0["avatar"] ?? "",
                           image: $0["image"] ?? "")
            }
            
            self.fillTable()
        }, errorHandler: { error in
            print(error.localizedDescription)
        })
        
    }
    
    fileprivate func fillTable() {
        newsTable.setNumberOfRows(newsStructs.count, withRowType: "WatchTable")
        for index in 0..<newsTable.numberOfRows {
            guard let controller = newsTable.rowController(at: index) as? NewsRowController else { continue }
            controller.news = newsStructs[index]
        }
    }
    
}
