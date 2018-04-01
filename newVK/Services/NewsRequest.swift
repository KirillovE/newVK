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
    private let method = "newsfeed.get"
    private let resultsCount = 100
    
    // MARK: - Methods
    
    func makeRequest(completion: @escaping ([News]) -> Void) {
        let (accessToken, apiVersion, url) = configureRequest()
        
        let parameters: Parameters = ["count": resultsCount,
                                      "access_token": accessToken,
                                      "v": apiVersion
        ]
        
        sessionManager?.request(url! + method, parameters: parameters).responseJSON {[weak self] response in
            guard let data = response.value else {return}
            let json = JSON(data)
            guard let news = self?.appendNews(from: json) else { return }
            completion(news)
        }
    }
    
    private func configureRequest() -> (String, Double, String?) {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        sessionManager = SessionManager(configuration: config)
        
        let accessToken = KeychainWrapper.standard.string(forKey: "access_token")!
        let userDefaults = UserDefaults.standard
        let apiVersion = userDefaults.double(forKey: "v")
        let url = userDefaults.string(forKey: "apiURL")
        
        return (accessToken, apiVersion, url ?? "")
    }
    
    private func appendNews(from json: JSON?) -> [News] {
        let itemsArray = json!["response", "items"]
        var newsArray = [News]()
        
        for (_, item) in itemsArray {
            let singlenews = News(json: item)
            manageAtachments(from: item, to: singlenews)
            if singlenews.sourceID >= 0 {
                addProfileInfo(from: json, to: singlenews)
            } else {
                addGroupInfo(from: json, to: singlenews)
            }
            newsArray.append(singlenews)
        }
        
        return newsArray
    }
    
    private func addProfileInfo(from json: JSON?, to news: News) {
        let profilesArray = json!["response", "profiles"]
        
        for (_, item) in profilesArray {
            if item["id"].intValue == news.sourceID {
                news.name = item["first_name"].stringValue + " " + item["last_name"].stringValue
                news.photoURL = item["photo_50"].stringValue
            }
        }
    }
    
    private func addGroupInfo(from json: JSON?, to news: News) {
        let groupsArray = json!["response", "groups"]
        
        for (_, item) in groupsArray {
            if item["id"].intValue == -news.sourceID {
                news.name = item["name"].stringValue
                news.photoURL = item["photo_50"].stringValue
            }
        }
    }
    
    private func manageAtachments(from array: JSON, to news: News) {
        let attachments = array["attachments"]
        for (_, item) in attachments {
            switch item["type"].stringValue {
            case "photo":
                let photoURL = item["photo", "photo_130"].stringValue
                news.imageURLs.append(photoURL)
            case "posted_photo":
                let photoURL = item["posted_photo", "photo_130"].stringValue
                news.imageURLs.append(photoURL)
            case "video":
                let photoURL = item["video", "photo_130"].stringValue
                news.imageURLs.append(photoURL)
            case "graffiti":
                let photoURL = item["graffiti", "photo_130"].stringValue
                news.imageURLs.append(photoURL)
            default:
                break
            }
        }
    }
    
}
