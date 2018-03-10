//
//  VKItem.swift
//  newVK
//
//  Created by Евгений Кириллов on 10.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import Foundation
import SwiftyJSON

class VKItem {
    var id = 0
    
    init(json: JSON) {
        id = json["id"].intValue
    }
}
