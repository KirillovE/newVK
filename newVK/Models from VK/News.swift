//
//  News.swift
//  newVK
//
//  Created by Евгений Кириллов on 29.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

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
    
    private let formatting = Formatting()
    
    let newsType: String
    let sourceID: Int
    let date: Double
    let text: String
    var comments = Comments()
    var likes = Likes()
    var reposts = Reposts()
    var viewsCount: Int
    
    // свойства, неизвестные в момент инициализации
    var name = ""
    var photoURL = ""
    var attachedImageURL = ""
    var attachedImageWidth = 0.0
    var attachedImageHeight = 0.0
    var day = ""
    var time = ""
    
    init(json: JSON) {
        newsType = json["type"].stringValue
        sourceID = json["source_id"].intValue
        text = json["text"].stringValue
        
        date = json["date"].doubleValue
        day = formatting.formatDate(date, outputFormat: .day)
        time = formatting.formatDate(date, outputFormat: .time)
        
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
