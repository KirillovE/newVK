//
//  LeaveAccount.swift
//  newVK
//
//  Created by Евгений Кириллов on 21.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation

class LeaveAccount {
    
    func logOut() {
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            let domainName = cookie.domain
            let domainRange = domainName.range(of: "vk.com")
            guard !(domainRange?.isEmpty)! else { return }
            storage.deleteCookie(cookie)
        }
    }
    
}
