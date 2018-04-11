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
                news.imageURLs.append(photoURL)
            case "posted_photo":
                let photoURL = item["posted_photo", "photo_604"].stringValue
                news.imageURLs.append(photoURL)
            case "video":
                let photoURL = item["video", "photo_640"].stringValue
                news.imageURLs.append(photoURL)
            case "graffiti":
                let photoURL = item["graffiti", "photo_604"].stringValue
                news.imageURLs.append(photoURL)
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
