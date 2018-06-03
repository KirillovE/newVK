//
//  AppDelegate.swift
//  newVK
//
//  Created by Евгений Кириллов on 16.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import RealmSwift
import FirebaseCore
import UserNotifications
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // MARK: - Data for Watch app
    
    var session: WCSession?
    let newsRequest = NewsRequest()
    
    // MARK: - Data for fetching new friends
    
    let fetchFriendsRequestsGroup = DispatchGroup()
    var timer: DispatchSourceTimer?
    var lastUpdate: Date? {
        get { return UserDefaults.standard.object(forKey: "lastUpdate") as? Date }
        set { UserDefaults.standard.setValue(newValue, forKey: "lastUpdate") }
    }
    let checkFriends = CheckNewFriendsRequest()
    let checkFriendsInterval = 900.0
    let timeToHandleRequests = 10.0

    // MARK: - Methods
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { _, error in
            if error != nil { print(error.debugDescription) }
        }
        
        setSession()
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Начинаем проверку наличия запросов от друзей в фоне. На часах ", Date())
        if lastUpdate != nil, abs(lastUpdate!.timeIntervalSinceNow) < checkFriendsInterval {
            print("Недавно проверяли, рано ещё, не надо так часто дёргать")
            completionHandler(.noData)
            return
        }
        
        fetchFriendsRequestsGroup.enter()
        checkFriends.makeRequest { requestsCount, potentialFriends in
            print("Количество поступивших запросов: \(requestsCount)")
            if requestsCount != 0 {
                print("Идентификаторы потенциальных друзей: \(potentialFriends)")
                let saving = SavingObjects()
                let pendingFrineds = potentialFriends.map { PendingFriends(id: $0) }
                saving.save(objectsArray: pendingFrineds)
                DispatchQueue.main.async {
                    application.applicationIconBadgeNumber = requestsCount
                    self.fetchFriendsRequestsGroup.leave()
                }
            }
        }
        
        fetchFriendsRequestsGroup.notify(queue: .main) {
            print("Данные загружены в фоне")
            self.timer = nil
            self.lastUpdate = Date()
            completionHandler(.newData)
            return
        }
        
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now() + timeToHandleRequests)
        timer?.setEventHandler {
            print("Не успели выполнить запрос")
            self.fetchFriendsRequestsGroup.suspend()
            completionHandler(.failed)
            return
        }
        timer?.resume()
        
    }
    
    private func setSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }

}

// MARK: - Watch extension

extension AppDelegate: WCSessionDelegate {
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if message["request"] as? String == "News" {
            newsRequest.makeRequest(resultsCount: 20) { news in
                let newsStrings = news.map {
                    ["author": $0.name,
                     "text": $0.text,
                     "avatar": $0.photoURL,
                     "image": $0.attachedImageURL,
                     "day": $0.day,
                     "time": $0.time
                    ]
                }
                
                replyHandler(["newsFeed": newsStrings])
            }
        } else {
            let userDefaults = UserDefaults(suiteName: "group.newVK")
            guard let startFrom = userDefaults?.string(forKey: "start_from") else { return }
            newsRequest.makeRequest(resultsCount: 20, startFrom: startFrom) { news in
                let newsStrings = news.map {
                    ["author": $0.name,
                     "text": $0.text,
                     "avatar": $0.photoURL,
                     "image": $0.attachedImageURL,
                     "day": $0.day,
                     "time": $0.time
                    ]
                }
                
                replyHandler(["newsFeed": newsStrings])
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    
}
