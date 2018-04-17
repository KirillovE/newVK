//
//  NewsRequest.swift
//  newVK
//
//  Created by Евгений on 29.03.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

class NewsRequest {
    
    // MARK: - Source data
    
    private var sessionManager: SessionManager?
    let userDefaults = UserDefaults.standard
    private let method = "newsfeed.get"
    private let resultsCount = 10
    
    // MARK: - Methods
    
    func makeRequest(filter: String, startFrom: String = "", completion: @escaping ([News]) -> Void) {
        let (accessToken, apiVersion, url) = configureRequest()
        
        let parameters: Parameters = ["count": resultsCount,
                                      "filter": filter,
                                      "start_from": startFrom,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        sessionManager?.request(url! + method,
                                parameters: parameters).responseJSON(queue: DispatchQueue.global())
                                {[weak self] response in
                                    guard let data = response.value else { return }
                                    let json = JSON(data)
                                    let nextFrom = json["response", "next_from"].stringValue
                                    self?.userDefaults.set(nextFrom, forKey: "start_from")
                                    guard let news = self?.appendNews(from: json) else { return }
                                    completion(news)
        }
    }
    
    private func configureRequest() -> (String, Double, String?) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        
        let accessToken = KeychainWrapper.standard.string(forKey: "access_token")!
        let apiVersion = userDefaults.double(forKey: "v")
        let url = userDefaults.string(forKey: "apiURL")
        
        return (accessToken, apiVersion, url ?? "")
    }
    
}

// MARK: - Helper methods

extension NewsRequest {
    
    private func appendNews(from json: JSON?) -> [News] {
        let itemsArray = json!["response", "items"]
        var newsArray = [News]()
        
        for (_, item) in itemsArray {
            guard item["type"].stringValue == "post",
                hasNeededAttachments(newsArray: item) else { continue }
            
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
    
    private func hasNeededAttachments(newsArray: JSON) -> Bool {
        var hasAttachment = false
        let attachments = newsArray["attachments"]
        for (_, item) in attachments {
            if item["type"].stringValue == "photo" || item["type"].stringValue == "video" {
                hasAttachment = true
                break
            } else {
                hasAttachment = false
            }
        }
        return hasAttachment
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
