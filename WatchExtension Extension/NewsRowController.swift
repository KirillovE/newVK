//
//  NewsRowController.swift
//  WatchExtension Extension
//
//  Created by Евгений Кириллов on 02.06.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import WatchKit

class NewsRowController: NSObject {
    
    @IBOutlet var newsAuthor: WKInterfaceLabel!
    @IBOutlet var newsText: WKInterfaceLabel!
    
    var news: NewsStruct? {
        didSet {
            guard let news = news else { return }
            newsAuthor.setText(news.author)
            newsText.setText(news.text)
        }
    }
    
}
