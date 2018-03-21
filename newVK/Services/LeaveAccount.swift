//
//  LeaveAccount.swift
//  newVK
//
//  Created by Евгений Кириллов on 21.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftKeychainWrapper
import RealmSwift

class LeaveAccount {
    
    func logOut() {
        clearCookies()
        clearDefaults()
        clearDataBase()
    }
    
    private func clearCookies() {
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            let domainName = cookie.domain
            guard let _ = domainName.range(of: "vk.com") else { return }
            storage.deleteCookie(cookie)
        }
    }
    
    private func clearDefaults() {
        KeychainWrapper.standard.removeObject(forKey: "access_token")
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "isAuthorized")
        userDefaults.removeObject(forKey: "user_id")
        userDefaults.removeObject(forKey: "v")
        userDefaults.removeObject(forKey: "apiURL")
    }
    
    private func clearDataBase() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print(error)
        }
    }
    
}
