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
    
    // MARK: - Source data
    
    @IBOutlet var newsTable: WKInterfaceTable!
    var session: WCSession?
    var newsStructs = [NewsStruct]()
    
    // MARK: - Base settings
    
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
    
    // MARK: - Working with table
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        switch table.rowController(at: rowIndex) {
        case let controller where controller is NewsRowController:
            showDetails(rowIndex - 1)
        case let controller where controller is RefreshRowController:
            refreshNews()
        case let controller where controller is MoreRowController:
            loadMore()
        default:
            break
        }
    }
    
    fileprivate func showDetails(_ rowIndex: Int) {
        let news = newsStructs[rowIndex]
        if news.image != "" {
            let controllers = ["NewsText", "NewsImage"]
            presentController(withNames: controllers, contexts: [news, news])
        } else {
            presentController(withName: "NewsText", context: news)
        }
    }
    
    private func refreshNews() {
        session?.sendMessage(["request": "News"], replyHandler: { reply in
            guard let news = reply["newsFeed"] as? [[String: String]] else { return }
            
            self.newsStructs = news.map {
                NewsStruct(author: $0["author"] ?? "",
                           text: $0["text"] ?? "",
                           avatar: $0["avatar"] ?? "",
                           image: $0["image"] ?? "",
                           day: $0["day"] ?? "",
                           time: $0["time"] ?? ""
                )
            }
            
            self.fillTable()
        }, errorHandler: { error in
            print(error.localizedDescription)
        })
    }
    
    private func loadMore() {
        session?.sendMessage(["request": "OldNews"], replyHandler: { reply in
            guard let news = reply["newsFeed"] as? [[String: String]] else { return }
            
            self.newsStructs += news.map {
                NewsStruct(author: $0["author"] ?? "",
                           text: $0["text"] ?? "",
                           avatar: $0["avatar"] ?? "",
                           image: $0["image"] ?? "",
                           day: $0["day"] ?? "",
                           time: $0["time"] ?? ""
                )
            }
            
            self.fillTable()
        }, errorHandler: { error in
            print(error.localizedDescription)
        })
    }
    
}

// MARK: - Session delegate

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
                           image: $0["image"] ?? "",
                           day: $0["day"] ?? "",
                           time: $0["time"] ?? ""
                )
            }
            
            self.fillTable()
        }, errorHandler: { error in
            print(error.localizedDescription)
        })
        
    }
    
    fileprivate func fillTable() {
        let newsRowTypes = Array(repeating: "WatchTable", count: newsStructs.count)
        let rowTypes = ["Refresh"] + newsRowTypes + ["LoadMore"]
        newsTable.setRowTypes(rowTypes)
        
        for index in 0..<newsTable.numberOfRows {
            guard let controller = newsTable.rowController(at: index) as? NewsRowController else { continue }
            controller.news = newsStructs[index - 1]
        }
    }
    
}
