//
//  SavingObjects.swift
//  newVK
//
//  Created by Евгений Кириллов on 20.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation
import RealmSwift

class SavingObjects {
    
    func save<T: Object>(objectsArray: [T]) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL ?? "нет файла")
            let oldObjects = realm.objects(T.self)
            try realm.write {
                realm.delete(oldObjects)
                realm.add(objectsArray)
            }
        } catch {
            print(error)
        }
        
    }
}
