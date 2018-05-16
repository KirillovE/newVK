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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let fetchFriendsRequestsGroup = DispatchGroup()
    var timer: DispatchSourceTimer?
    var lastUpdate: Date? {
        get { return UserDefaults.standard.object(forKey: "lastUpdate") as? Date }
        set { UserDefaults.standard.setValue(newValue, forKey: "lastUpdate") }
    }
    let checkFriends = CheckNewFriendsRequest()
    let checkFriendsInterval = 900.0           //проверка каждые 15 минут
    let timeToHandleRequests = 10.0
    let content = UNMutableNotificationContent()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = config
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: .badge) { _, error in
            if error != nil { print(error.debugDescription) }
        }
        
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
                self.content.badge = requestsCount as NSNumber
            }
            self.fetchFriendsRequestsGroup.leave()
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

}
