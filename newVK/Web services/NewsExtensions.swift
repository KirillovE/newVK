//
//  NewsExtensions.swift
//  newVK
//
//  Created by Евгений Кириллов on 02.04.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftyJSON

extension NewsRequest {
    
    func appendNews(from json: JSON?) -> [News] {
        let itemsArray = json!["response", "items"]
        var newsArray = [News]()
        
        for (_, item) in itemsArray {
            guard item["type"].stringValue == "post" else { continue }
            
            let singleNews = News(json: item)
            manageAtachments(from: item, to: singleNews)
            if singleNews.sourceID >= 0 {
                addProfileInfo(from: json, to: singleNews)
            } else {
                addGroupInfo(from: json, to: singleNews)
            }
            newsArray.append(singleNews)
        }
        
        return newsArray
    }
    
    private func manageAtachments(from array: JSON, to news: News) {
        let attachments = array["attachments"]
        for (_, item) in attachments {
            switch item["type"].stringValue {
            case "photo":
                let photoURL = item["photo", "photo_604"].stringValue
                let photoWidth = item["photo", "width"].doubleValue
                let photoHeight = item["photo", "height"].doubleValue
                
                news.attachedImageURL = photoURL
                news.attachedImageWidth = photoWidth
                news.attachedImageHeight = photoHeight
            case "video":
                let photoURL = item["video", "photo_640"].stringValue
                news.attachedImageURL = photoURL
                news.attachedImageWidth = 640.0
                news.attachedImageHeight = 480.0
            default:
                break
            }
        }
    }
    
    private func addProfileInfo(from json: JSON?, to news: News) {
        let profilesArray = json!["response", "profiles"]
        
        for (_, item) in profilesArray {
            if item["id"].intValue == news.sourceID {
                news.name = item["first_name"].stringValue + " " + item["last_name"].stringValue
                news.photoURL = item["photo_medium_rec"].stringValue
            }
        }
    }
    
    private func addGroupInfo(from json: JSON?, to news: News) {
        let groupsArray = json!["response", "groups"]
        
        for (_, item) in groupsArray {
            if item["id"].intValue == -news.sourceID {
                news.name = item["name"].stringValue
                news.photoURL = item["photo_100"].stringValue
            }
        }
    }
    
}
