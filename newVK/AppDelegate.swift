//
//  AppDelegate.swift
//  newVK
//
//  Created by Евгений Кириллов on 16.02.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import RealmSwift
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = config
        FirebaseApp.configure()
        
        return true
    }

}
