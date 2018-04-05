//
//  News.swift
//  newVK
//
//  Created by Евгений Кириллов on 29.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import RealmSwift
import SwiftyJSON

struct Comments {
    var count = 0
    var canPost = false
}

struct Likes {
    var count = 0
    var userLikes = false
    var canLike = false
    var canPublish = false
}

struct Reposts {
    var count = 0
    var userReposted = false
}

class News {
    let newsType: String
    let sourceID: Int
    let day, time: String
    let text: String
    var comments = Comments()
    var likes = Likes()
    var reposts = Reposts()
    var viewsCount: Int
    
    // свойства, неизвестные в момент инициализации
    var name = ""
    var photoURL = ""
    var imageURLs = [String]()
    
    init(json: JSON) {
        newsType = json["type"].stringValue
        sourceID = json["source_id"].intValue
        
        let doubleDate = json["date"].doubleValue
        let dateFormatterForDay = DateFormatter()
        let dateFormatterForTime = DateFormatter()
        dateFormatterForDay.dateFormat = "dd.MM.yyyy"
        dateFormatterForTime.dateFormat = "HH.mm"
        let numberDate = Date(timeIntervalSince1970: doubleDate)
        day = dateFormatterForDay.string(from: numberDate)
        time = dateFormatterForTime.string(from: numberDate)
        
        text = json["text"].stringValue
        
        comments.count = json["comments", "count"].intValue
        comments.canPost = json["comments", "can_post"].boolValue
        
        likes.count = json["likes", "count"].intValue
        likes.userLikes = json["likes", "user_likes"].boolValue
        likes.canLike = json["likes", "can_like"].boolValue
        likes.canPublish = json["likes", "can_publish"].boolValue
        
        reposts.count = json["reposts", "count"].intValue
        reposts.userReposted = json["reposts", "user_reposted"].boolValue
        
        viewsCount = json["views", "count"].intValue
    }
}