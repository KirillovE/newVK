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
    
    func saveIndexOfUser(authorizedUser id: String?) {
        guard let userID = id else { return }
        let ref = Database.database().reference()
        let dict = ["ID": userID]
        
        ref.child("Users").observeSingleEvent(of: .value) { snapshot in
            let json = JSON(snapshot.value as Any)
            let usersArray = json.arrayValue
            
            if let indexOfUser = self.indexOf(id: userID, in: usersArray) {
                self.userDefaults.set(indexOfUser, forKey: "numberOfUserInFirebase")
            } else {
                let newIndex = String(usersArray.count)
                ref.child("Users").updateChildValues([newIndex: dict])
                self.userDefaults.set(newIndex, forKey: "numberOfUserInFirebase")
            }
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
    
    func addGroup(_ group: Group) {
        let groupID = String(group.id)
        let numberOfUser = userDefaults.integer(forKey: "numberOfUserInFirebase")
        let ref = Database.database().reference()
        
        ref.child("Users/\(numberOfUser)/Groups").observeSingleEvent(of: .value) { snapshot in
//            if !snapshot.exists() {
//                ref.child("Users/\(numberOfUser)/Groups").setValue([groupID])
//            } else {
                let json = JSON(snapshot.value as Any)
                let groupsArray = json.arrayValue
                for (index, id) in groupsArray.enumerated() {
                    if groupID == id.stringValue {
                        print("номер совпавшего элемента \(index)")
                        return
                    }
                }
                let newIndex = String(groupsArray.count)
                ref.child("Users/\(numberOfUser)/Groups").updateChildValues([newIndex: groupID])
//            }
        }
    }
    
}
