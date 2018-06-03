//
//  NewsTextInterfaceController.swift
//  WatchExtension Extension
//
//  Created by Евгений Кириллов on 02.06.2018.
//  Copyright © 2018 Триада. All rights reserved.
//

import WatchKit
import Foundation


class TextInterfaceController: WKInterfaceController {
    
    // MARK: - Source data
    
    @IBOutlet var avatar: WKInterfaceImage!
    @IBOutlet var authorName: WKInterfaceLabel!
    @IBOutlet var newsText: WKInterfaceLabel!
    @IBOutlet var day: WKInterfaceLabel!
    @IBOutlet var time: WKInterfaceLabel!
    
    var news: NewsStruct? {
        didSet {
            authorName.setText(news?.author)
            newsText.setText(news?.text)
            day.setText(news?.day)
            time.setText(news?.time)
            setPicture(fromURL: news?.avatar)
        }
    }

    // MARK: - Methods

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let news = context as? NewsStruct {
            self.news = news
        }
    }
    
    private func setPicture(fromURL urlString: String?) {
        guard let urlString = urlString,
            let url = URL(string: urlString) else { return }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            self.avatar.setImageData(data)
        }
    }
    
}
