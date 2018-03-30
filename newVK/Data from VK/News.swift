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
    let date: Date
    let text: String
    var comments = Comments()
    var likes = Likes()
    var reposts = Reposts()
    var viewsCount: Int
    
    init(json: JSON) {
        newsType = json["type"].stringValue
        sourceID = json["source_id"].intValue
        
        let doubleDate = json["date"].doubleValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH.mm"
        date = Date(timeIntervalSince1970: doubleDate)
        
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
