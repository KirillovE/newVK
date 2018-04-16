//
//  WorkWithFirebase.swift
//  newVK
//
//  Created by Евгений Кириллов on 16.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import FirebaseDatabase
import SwiftyJSON

class WorkWithFirebase {
    
    let userDefaults = UserDefaults.standard
    let ref = Database.database().reference()
    
    func saveIndexOfUser(authorizedUser id: String?) {
        guard let userID = id else { return }
        let dict = ["ID": userID]
        
        ref.child("Users").observeSingleEvent(of: .value) { snapshot in
            let json = JSON(snapshot.value as Any)
            let usersArray = json.arrayValue
            
            if let indexOfUser = self.indexOf(id: userID, in: usersArray) {
                self.userDefaults.set(indexOfUser, forKey: "numberOfUserInFirebase")
            } else {
                let newIndex = String(usersArray.count)
                self.ref.child("Users").updateChildValues([newIndex: dict])
                self.userDefaults.set(newIndex, forKey: "numberOfUserInFirebase")
            }
        }
    }
    
    func addGroup(_ group: Group) {
        let groupID = String(group.id)
        let numberOfUser = userDefaults.integer(forKey: "numberOfUserInFirebase")
        
        ref.child("Users/\(numberOfUser)/Groups").observeSingleEvent(of: .value) { snapshot in
            let json = JSON(snapshot.value as Any)
            let groupsArray = json.arrayValue
            guard !self.alreadyHas(groupWithID: groupID, in: groupsArray) else { return }
            
            let newIndex = String(groupsArray.count)
            self.ref.child("Users/\(numberOfUser)/Groups").updateChildValues([newIndex: groupID])
        }
    }
    
    private func indexOf(id: String, in array: [JSON]) -> String? {
        for (index, userDict) in array.enumerated() {
            if id == userDict["ID"].stringValue {
                return String(index)
            }
        }
        return nil
    }
    
    private func alreadyHas(groupWithID id: String, in array: [JSON]) -> Bool {
        for item in array {
            if id == item.stringValue {
                return true
            }
        }
        return false
    }
    
}
